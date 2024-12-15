#!/bin/bash
#
# Copyright (C) 2021 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

declare -a SOURCE_PATHS=();
declare -A SOURCE_BRANCH=();
declare -a FILELIST_PATHS=();
declare -a PATCH_PATHS=();
declare -a HOOK_PATHS=();

VENDOR_STATE=-1

TMPDIR=$(mktemp -d)

#
# cleanup
#
# kill our tmpfiles with fire on exit
#
function cleanup() {
    rm -rf "${TMPDIR:?}"
}

trap cleanup 0

# To be overridden by device-level hooks.sh
# Parameters:
#   $1: Name of the source. Used as the basename.
#   $2: Type of the source
#
function handle_extract() {
    return -1;
}

#
# setup_vendor
#
# $1: device name
# $2: vendor name
# $3: Lineage root directory
# $4: is common device - optional, default to false
# $5: cleanup - optional, default to true
# $6: custom vendor makefile name - optional, default to false
#
# Must be called before any other functions can be used. This
# sets up the internal state for a new vendor configuration.
#
function setup_vendor() {
    local DEVICE="$1"
    if [ -z "$DEVICE" ]; then
        echo "\$DEVICE must be set before including this script!"
        exit 1
    fi

    export VENDOR="$2"
    if [ -z "$VENDOR" ]; then
        echo "\$VENDOR must be set before including this script!"
        exit 1
    fi

    export LINEAGE_ROOT="$3"
    if [ ! -d "$LINEAGE_ROOT" ]; then
        echo "\$LINEAGE_ROOT must be set and valid before including this script!"
        exit 1
    fi

    export PATH="${LINEAGE_ROOT}/out/host/linux-x86/bin":"$PATH";
    for CMD in 'brotli' '7z' 'simg2img' 'tar' 'ar' 'zstd' 'wget' 'identify' 'convert'; do
        command -v ${CMD} >/dev/null 2>&1 || { echo >&2 "${CMD} is required, but not installed. Aborting."; exit 1; }
    done

    if [ -z "$PATCHELF_VERSION" ]; then
        PATCHELF_VERSION=0_18;
    fi;
    mapfile -td \_ PE_VER < <(printf "%s\0" "${PATCHELF_VERSION}")
    PE_VER[2]=${PE_VER[2]:-0};

    if command -v "${LINEAGE_ROOT}/prebuilts/extract-tools/linux-x86/bin/patchelf-${PATCHELF_VERSION}" >/dev/null 2>&1; then
        export PATH="${LINEAGE_ROOT}/prebuilts/extract-tools/linux-x86/bin":"$PATH";
        PATCHELF=patchelf-${PATCHELF_VERSION};
    elif command -v patchelf >/dev/null 2>&1 && [ "$(patchelf --version)" == "patchelf ${PE_VER[0]}.${PE_VER[1]}.${PE_VER[2]}" ]; then
        PATCHELF=patchelf;
    else
        echo >&2 "patchelf ${PE_VER[0]}.${PE_VER[1]}.${PE_VER[2]} is required, but not installed. Aborting.";
        exit 1;
    fi;

    export OUTDIR=vendor/nvidia
    if [ ! -d "$LINEAGE_ROOT/$OUTDIR" ]; then
        mkdir -p "$LINEAGE_ROOT/$OUTDIR"
    fi

    if [ "$5" == "false" ] || [ "$5" == "0" ]; then
        VENDOR_STATE=1
    else
        VENDOR_STATE=0
    fi

    for sources in ${LINEAGE_ROOT}/device/nvidia/*/extract/extract_sources.sh; do
        source "$sources";
    done;
    for key in "${!SOURCE_PATHS[@]}"; do
        SOURCE_PATHS["$key"]=nvidia/${SOURCE_PATHS["$key"]};
    done;
    for key in "${!FILELIST_PATHS[@]}"; do
        FILELIST_PATHS["$key"]=nvidia/${FILELIST_PATHS["$key"]};
    done;
    for key in "${!PATCH_PATHS[@]}"; do
        PATCH_PATHS["$key"]=nvidia/${PATCH_PATHS["$key"]};
    done;
    for key in "${!HOOK_PATHS[@]}"; do
        HOOK_PATHS["$key"]=nvidia/${HOOK_PATHS["$key"]};
    done;
    if [ "${VENDOR}" != "nvidia" ]; then
        source ${LINEAGE_ROOT}/device/${VENDOR}/${DEVICE}/extract/extract_sources.sh;
    fi;
}

#
# Download and extract source archives
#
function fetch_sources() {
    local LINEAGE_TOOLS=${LINEAGE_ROOT}/tools/extract-utils
    local COMMON_EXTRACT=${LINEAGE_ROOT}/device/nvidia/tegra-common/extract

    mkdir ${TMPDIR}/downloads;
    mkdir ${TMPDIR}/extract;

    for key in "${!SOURCE_PATHS[@]}"; do
        while read -r sname url type branch extra_path; do
            SOURCE_BRANCH[${sname}]="${branch}";
            ESPATH="${TMPDIR}/extract/${sname}";
            mkdir ${ESPATH};

            fileext="zip";
            if [ "${type}" == "git" -o "${type}" == "gitiles" ]; then
                fileext="sh";
            elif [ "${type}" == "l4t" ]; then
                fileext="tbz2";
            fi;

            if [ "$1" != "download" -a -f "$1/$(echo ${url} |awk -F/ '{ print $NF }')" ]; then
                cp "$1/$(echo ${url} |awk -F/ '{ print $NF }')" ${TMPDIR}/downloads/${sname}.${fileext};
            elif [ "$1" != "download" -a -f "$1/${sname}.${fileext}" ]; then
                cp "$1/${sname}.${fileext}" ${TMPDIR}/downloads/${sname}.${fileext};
            fi;
            if [ ! -f ${TMPDIR}/downloads/${sname}.${fileext} ]; then
                echo -n "Downloading source ${sname} from ${url}...";
                wget ${url} -O ${TMPDIR}/downloads/${sname}.${fileext} 1>/dev/null 2>&1;

                if [ "${type}" == "gitiles" ]; then
                    mv ${TMPDIR}/downloads/${sname}.sh ${TMPDIR}/downloads/${sname}.base64;
                    base64 --decode ${TMPDIR}/downloads/${sname}.base64 > ${TMPDIR}/downloads/${sname}.sh;
                    rm ${TMPDIR}/downloads/${sname}.base64;
                fi;
                echo "";
            fi;

            echo -n "Extracting source ${sname} for prebuilts branch ${branch}...";
            local extract_handled="false";
            for hook in "${!HOOK_PATHS[@]}"; do
                source "${LINEAGE_ROOT}/device/${HOOK_PATHS["$hook"]}/extract/hooks.sh";
                if handle_extract "${sname}" "${type}"; then extract_handled="true"; break; fi;
            done;
            if [ "$extract_handled" == "true" ]; then
                rm -f ${TMPDIR}/downloads/${sname}.${fileext};
                echo "";
                continue;
            fi;

            if [ "${type}" == "git" -o "${type}" == "gitiles" ]; then
                tail -n +$(($(grep -an "^\s*__START_TGZ_FILE__" ${TMPDIR}/downloads/${sname}.sh \
                            | awk -F ':' '{print $1}') + 1)) ${TMPDIR}/downloads/${sname}.sh \
                  | tar zxv -C ${ESPATH} 1>/dev/null 2>&1;

                if [ ! -z "${extra_path}" ]; then
                    mv ${ESPATH}/${extra_path}/* ${ESPATH}/;
                fi;
            elif [ "${type}" == "l4t" ]; then
                mkdir ${ESPATH}/drivers;
                tar -xf ${TMPDIR}/downloads/${sname}.tbz2 -C ${ESPATH} 1>/dev/null 2>&1;
                mv ${ESPATH}/Linux_for_Tegra/* ${ESPATH}/;
                rmdir ${ESPATH}/Linux_for_Tegra;
                tar -xf ${ESPATH}/nv_tegra/nvidia_drivers.tbz2 -C ${ESPATH}/drivers 1>/dev/null 2>&1;
            elif [ "${type}" == "blob" ]; then
                # Only extract blob
                unzip -d ${ESPATH} ${TMPDIR}/downloads/${sname}.zip blob 1>/dev/null 2>&1 || \
		(unzip -d ${ESPATH} ${TMPDIR}/downloads/${sname}.zip nvota.bin 1>/dev/null 2>&1 && mv ${ESPATH}/nvota.bin ${ESPATH}/blob);
            else
                unzip -d ${ESPATH} ${TMPDIR}/downloads/${sname}.zip 1>/dev/null 2>&1;

                case "${type}" in
                    "nv-recovery-t114")
                        mkdir ${ESPATH}/temp;
                        mkdir ${ESPATH}/system;

                        mv ${ESPATH}/extract-nv-recovery-image-*.sh ${ESPATH}/extract-nv.sh
                        tail -n +$(($(grep -an "^\s*__START_TGZ_FILE__" ${ESPATH}/extract-nv.sh \
                                    | awk -F ':' '{print $1}') + 1)) ${ESPATH}/extract-nv.sh \
                          | tar zxv -C ${ESPATH}/temp 2>&1 1>/dev/null 2>&1;

                        simg2img ${ESPATH}/temp/system.img ${ESPATH}/system.img;
                        # 7z complains about 'dangerous symlinks', so the return value must be ignored
                        7z x -o${ESPATH}/system ${ESPATH}/system.img 1>/dev/null 2>&1 || true;

                        rm -rf \
                          ${ESPATH}/temp \
                          ${ESPATH}/extract-nv.sh \
                          ${ESPATH}/system.img;
                        ;;

                    "nv-recovery-no-vendor")
                        mkdir ${ESPATH}/system;

                        simg2img ${ESPATH}/nv-recovery-*/system.img ${ESPATH}/system.img;
                        # 7z complains about 'dangerous symlinks', so the return value must be ignored
                        7z x -o${ESPATH}/system ${ESPATH}/system.img 1>/dev/null 2>&1 || true;

			mv ${ESPATH}/nv-recovery-*/blob ${ESPATH}/blob || true;

                        rm -rf \
                          ${ESPATH}/nv-recovery-* \
                          ${ESPATH}/system.img;
                        ;;

                    "nv-recovery")
                        mkdir ${ESPATH}/system;
                        mkdir ${ESPATH}/vendor;

                        simg2img ${ESPATH}/nv-recovery-image-*/system.img ${ESPATH}/system.img;
                        # 7z complains about 'dangerous symlinks', so the return value must be ignored
                        7z x -o${ESPATH}/system ${ESPATH}/system.img 1>/dev/null 2>&1 || true;

                        simg2img ${ESPATH}/nv-recovery-image-*/vendor.img ${ESPATH}/vendor.img;
                        # 7z complains about 'dangerous symlinks', so the return value must be ignored
                        7z x -o${ESPATH}/vendor ${ESPATH}/vendor.img 1>/dev/null 2>&1 || true;

			mv ${ESPATH}/nv-recovery-*/blob ${ESPATH}/blob || true;

                        rm -rf \
                          ${ESPATH}/nv-recovery-image-* \
                          ${ESPATH}/system.img \
                          ${ESPATH}/vendor.img;
                        ;;

                    "nv-recovery-ota")
                        mkdir ${ESPATH}/system;
                        mkdir ${ESPATH}/vendor;

                        brotli -d ${ESPATH}/system.new.dat.br;
                        python ${LINEAGE_TOOLS}/sdat2img.py \
                          ${ESPATH}/system.transfer.list \
                          ${ESPATH}/system.new.dat \
                          ${ESPATH}/system.img 1>/dev/null 2>&1;
                        # 7z complains about 'dangerous symlinks', so the return value must be ignored
                        7z x -o${ESPATH}/system ${ESPATH}/system.img 1>/dev/null 2>&1 || true;

                        brotli -d ${ESPATH}/vendor.new.dat.br
                        python ${LINEAGE_TOOLS}/sdat2img.py \
                          ${ESPATH}/vendor.transfer.list \
                          ${ESPATH}/vendor.new.dat \
                          ${ESPATH}/vendor.img 1>/dev/null 2>&1;
                        # 7z complains about 'dangerous symlinks', so the return value must be ignored
                        7z x -o${ESPATH}/vendor ${ESPATH}/vendor.img 1>/dev/null 2>&1 || true;

                        rm -rf \
                          ${ESPATH}/system.* \
                          ${ESPATH}/vendor.* \
                          ${ESPATH}/boot.img \
                          ${ESPATH}/compatibility.zip \
                          ${ESPATH}/META-INF;
                        ;;
                esac;
            fi;

            if [ -f ${ESPATH}/blob ]; then
                mkdir -p ${ESPATH}/bootloader;
                python ${COMMON_EXTRACT}/nvblob_extract.py ${ESPATH}/blob ${ESPATH}/bootloader 1>/dev/null 2>&1;
            fi;

            if [ -f ${ESPATH}/bmp.blob ]; then
                BLOB_HEADER_SIZE=$((16#$(xxd -s 24 -l 1 -p ${ESPATH}/bmp.blob)));
                if [ "$(xxd -s ${BLOB_HEADER_SIZE} -l 4 -p ${ESPATH}/bmp.blob)" == "02214c18" ]; then
                    mv ${ESPATH}/bmp.blob ${ESPATH}/bmp.blob.comp;
                    dd if=${ESPATH}/bmp.blob.comp bs=1 count=${BLOB_HEADER_SIZE} status=none of=${ESPATH}/bmp.blob;
                    dd if=${ESPATH}/bmp.blob.comp bs=1 skip=${BLOB_HEADER_SIZE} status=none |unlz4 >> ${ESPATH}/bmp.blob;
                    rm ${ESPATH}/bmp.blob.comp;
                fi;

                mkdir -p ${ESPATH}/bmp;
                python ${COMMON_EXTRACT}/nvblob_extract.py ${ESPATH}/bmp.blob ${ESPATH}/bmp 1>/dev/null 2>&1;
            fi;

            rm -f ${TMPDIR}/downloads/${sname}.${fileext};
            echo "";
        done < "${LINEAGE_ROOT}/device/${SOURCE_PATHS["$key"]}/extract/sources.txt";
    done;
}

#
# Copy prebuilts
#
function copy_files() {
    echo "Copying files...";

    declare -a MISSING_PATHS=();

    for key in "${!FILELIST_PATHS[@]}"; do
        local project="${FILELIST_PATHS["$key"]}";
        if [ "${project}" == "nvidia/tegra-common" ]; then
            project="nvidia/common";
        else
            project=${project%"-common"};
        fi;

        while read -r sname source dest; do
            if [ -z "${sname#"#"}"  ]; then continue; fi;

            if [ "${dest: -1}" == "/" ]; then
                dest="${dest}$(basename ${source})";
            fi;

            if [ -f "${TMPDIR}/extract/${sname}/${source}" ]; then
                echo "  * ${project}/${SOURCE_BRANCH[$sname]}/${dest}";
                mkdir -p ${LINEAGE_ROOT}/vendor/$(dirname ${project}/${SOURCE_BRANCH[$sname]}/$dest);

                # If asked to unstrip elf file, check for the debugdata section.
                # If ivrodata section exists, ignore file because the extra sections confuse unstrip.
                if [ -n "${EXTRACT_UNSTRIP}" ] && file -b ${TMPDIR}/extract/${sname}/${source} |grep ^ELF 2>&1 1>/dev/null && \
                   llvm-objdump -h ${TMPDIR}/extract/${sname}/${source} |grep gnu_debugdata 2>&1 > /dev/null && \
                   ! (llvm-objdump -h ${TMPDIR}/extract/${sname}/${source} |grep ivrodata 2>&1 > /dev/null); then
                    echo "    - Found debugdata";
                    llvm-objcopy --dump-section .gnu_debugdata=/dev/stdout ${TMPDIR}/extract/${sname}/${source} | xz -d > ${TMPDIR}/extract/${sname}/${source}.dbg;
                    eu-unstrip ${TMPDIR}/extract/${sname}/${source} ${TMPDIR}/extract/${sname}/${source}.dbg -o ${LINEAGE_ROOT}/vendor/${project}/${SOURCE_BRANCH[$sname]}/${dest};
                else
                    cp ${TMPDIR}/extract/${sname}/${source} ${LINEAGE_ROOT}/vendor/${project}/${SOURCE_BRANCH[$sname]}/${dest};
                fi;
            else
                echo "  X ${source} is missing from ${sname} for ${project}";
		MISSING_PATHS+=("${project}/${SOURCE_BRANCH[$sname]}/${dest}");
            fi;
        done < "${LINEAGE_ROOT}/device/${FILELIST_PATHS["$key"]}/extract/file.list";

        find ${LINEAGE_ROOT}/vendor/${project} -type f -exec chmod 644 {} \;
    done;

    if [ ! ${#MISSING_PATHS[@]} -eq 0 ]; then
        echo "";
        echo "Some targets failed to extract:";
        for path in "${MISSING_PATHS[@]}"; do
            echo "  ${path}";
        done;
	exit -1;
    fi;

    echo "Finished copying files.";
}

#
# Handle patches
#
function do_patches() {
    for key in "${!PATCH_PATHS[@]}"; do
      echo "Starting patches for ${PATCH_PATHS["$key"]}.";

      set +e;
      source "${LINEAGE_ROOT}/device/${PATCH_PATHS["$key"]}/extract/patches.sh";
      set -e;

      echo "Finished patches for ${PATCH_PATHS["$key"]}.";
    done;
}

#
# extract:
#
# Positional parameters:
# $1: file containing the list of items to extract (aka proprietary-files.txt)
# $2: path to extracted system folder, an ota zip file, or "adb" to extract from device
# $3: section in list file to extract - optional. Setting section via $3 is deprecated.
#
# Non-positional parameters (coming after $2):
# --section: preferred way of selecting the portion to parse and extract from
#            proprietary-files.txt
# --kang: if present, this option will activate the printing of hashes for the
#         extracted blobs. Useful with --section for subsequent pinning of
#         blobs taken from other origins.
#
function extract() {
    # Consume positional parameters
    local PROPRIETARY_FILES_TXT="$1"; shift
    local SRC="$1"; shift
    local SECTION=""
    local KANG=false

    # Consume optional, non-positional parameters
    while [ "$#" -gt 0 ]; do
        case "$1" in
        -s|--section)
            SECTION="$2"; shift
            ;;
        -k|--kang)
            KANG=true
            DISABLE_PINNING=1
            ;;
        esac
        shift
    done

    if [ -z "$OUTDIR" ]; then
        echo "Output dir not set!"
        exit 1
    fi

    if [ "$VENDOR_STATE" -eq "0" ]; then
        for key in "${!FILELIST_PATHS[@]}"; do
            local project="${FILELIST_PATHS["$key"]}";
            if [ "${project}" == "nvidia/tegra-common" ]; then
                project="nvidia/common";
            else
                project=${project%"-common"};
            fi;
            echo "Cleaning output directory (vendor/$project)...";
            rm -rf ${LINEAGE_ROOT}/vendor/${project}/*;
        done;
        VENDOR_STATE=1;
    fi;

    fetch_sources $SRC;
    copy_files;
    do_patches;
}
