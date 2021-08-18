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
declare -a FILELIST_PATHS=();
declare -a PATCH_PATHS=();

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

    if [ ! -f "${LINEAGE_ROOT}/out/host/linux-x86/bin/brotli" ]; then
        echo "otatools must be built before running this script!"
        exit 1
    fi

    export OUTDIR=vendor/"$VENDOR"
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
      cat "${LINEAGE_ROOT}/device/nvidia/${SOURCE_PATHS["$key"]}/extract/sources.txt" >> "$TMPDIR/sources.txt";
    done;

    for key in "${!FILELIST_PATHS[@]}"; do
      cat "${LINEAGE_ROOT}/device/nvidia/${FILELIST_PATHS["$key"]}/extract/file.list" >> "$TMPDIR/file.list";
    done;
}

#
# Download and extract source archives
#
function fetch_sources() {
    local HOST_BINS=${LINEAGE_ROOT}/out/host/linux-x86/bin
    local LINEAGE_TOOLS=${LINEAGE_ROOT}/vendor/lineage/build/tools

    mkdir ${TMPDIR}/downloads;
    mkdir ${TMPDIR}/extract;

    while read -r sname url type extra_path; do
        ESPATH="${TMPDIR}/extract/${sname}";
        mkdir ${ESPATH};

        fileext="zip";
        if [ "${type}" == "git" ]; then
            fileext="sh";
        elif [ "${type}" == "l4t" ]; then
            fileext="tbz2";
        fi;

        wget ${url} -O ${TMPDIR}/downloads/${sname}.${fileext};

        if [ "${type}" == "git" ]; then
            tail -n +$(($(grep -an "^\s*__START_TGZ_FILE__" ${TMPDIR}/downloads/${sname}.sh \
                        | awk -F ':' '{print $1}') + 1)) ${TMPDIR}/downloads/${sname}.sh \
              | tar zxv -C ${ESPATH};
        elif [ "${type}" == "l4t" ]; then
            mkdir ${ESPATH}/drivers;
            tar -xf ${TMPDIR}/downloads/${sname}.tbz2 -C ${ESPATH}
            tar -xf ${ESPATH}/Linux_for_Tegra/nv_tegra/nvidia_drivers.tbz2 -C ${ESPATH}/drivers
        else
            unzip -d ${ESPATH} ${TMPDIR}/downloads/${sname}.zip;

            case "${type}" in
                "nv-recovery-t114")
                    mkdir ${ESPATH}/temp;
                    mkdir ${ESPATH}/system;

                    mv ${ESPATH}/extract-nv-recovery-image-*.sh ${ESPATH}/extract-nv.sh
                    tail -n +$(($(grep -an "^\s*__START_TGZ_FILE__" ${ESPATH}/extract-nv.sh \
                                | awk -F ':' '{print $1}') + 1)) ${ESPATH}/extract-nv.sh \
                      | tar zxv -C ${ESPATH}/temp;

                    ${HOST_BINS}/simg2img ${ESPATH}/temp/system.img ${ESPATH}/system.img;
                    7z x -o${ESPATH}/system ${ESPATH}/system.img;

                    rm -rf \
                      ${ESPATH}/temp \
                      ${ESPATH}/extract-nv.sh \
                      ${ESPATH}/system.img;
                    ;;

                "nv-recovery-no-vendor")
                    mkdir ${ESPATH}/system;

                    ${HOST_BINS}/simg2img ${ESPATH}/nv-recovery-*/system.img ${ESPATH}/system.img;
                    7z x -o${ESPATH}/system ${ESPATH}/system.img;

                    rm -rf \
                      ${ESPATH}/nv-recovery-* \
                      ${ESPATH}/system.img;
                    ;;

                "nv-recovery")
                    mkdir ${ESPATH}/system;
                    mkdir ${ESPATH}/vendor;

                    ${HOST_BINS}/simg2img ${ESPATH}/nv-recovery-image-*/system.img ${ESPATH}/system.img;
                    7z x -o${ESPATH}/system ${ESPATH}/system.img;

                    ${HOST_BINS}/simg2img ${ESPATH}/nv-recovery-image-*/vendor.img ${ESPATH}/vendor.img;
                    7z x -o${ESPATH}/vendor ${ESPATH}/vendor.img;

                    rm -rf \
                      ${ESPATH}/nv-recovery-image-* \
                      ${ESPATH}/system.img \
                      ${ESPATH}/vendor.img;
                    ;;

                "nv-recovery-ota")
                    mkdir ${ESPATH}/system;
                    mkdir ${ESPATH}/vendor;

                    ${HOST_BINS}/brotli -d ${ESPATH}/system.new.dat.br;
                    python ${LINEAGE_TOOLS}/sdat2img.py \
                      ${ESPATH}/system.transfer.list \
                      ${ESPATH}/system.new.dat \
                      ${ESPATH}/system.img;
                    7z x -o${ESPATH}/system ${ESPATH}/system.img;

                    ${HOST_BINS}/brotli -d ${ESPATH}/vendor.new.dat.br
                    python ${LINEAGE_TOOLS}/sdat2img.py \
                      ${ESPATH}/vendor.transfer.list \
                      ${ESPATH}/vendor.new.dat \
                      ${ESPATH}/vendor.img;
                    # symlinks causes errors here, but not elsewhere?
                    7z x -o${ESPATH}/vendor ${ESPATH}/vendor.img || true;

                    rm -rf \
                      ${ESPATH}/system.* \
                      ${ESPATH}/vendor.* \
                      ${ESPATH}/boot.img \
                      ${ESPATH}/blob \
                      ${ESPATH}/bmp.blob \
                      ${ESPATH}/compatibility.zip \
                      ${ESPATH}/META-INF;
                    ;;
            esac;
        fi;

        rm -f ${TMPDIR}/downloads/${sname}.${fileext};
    done < ${TMPDIR}/sources.txt;
}

#
# Copy prebuilts
#
function copy_files() {
    while read -r sname url type extra_path; do
        while read -r fname source dest; do
            if [ "$sname" == "$fname" ]; then
                mkdir -p ${LINEAGE_ROOT}/${OUTDIR}/$(dirname $dest);

                extrapath="$extra_path"
                if [[ ${source} != "${source/bcmbinaries/}" ]]; then
                    extrapath="prebuilt/t210"
                elif [[ ${source} != "${source/cypress/}" ]]; then
                    extrapath="prebuilt/t210"
                elif [[ ${source} != "${source/model_frontal/}" ]]; then
                    extrapath=""
                elif [[ ${source} != "${source/linux-x86/}" ]]; then
                    extrapath="prebuilt/t210"
                elif [[ ${source} != "${source/tnspec/}" ]]; then
                    extrapath=""
                fi;

                cp ${TMPDIR}/extract/${sname}/${extrapath}/${source} ${LINEAGE_ROOT}/${OUTDIR}/${dest};
            fi;
        done < ${TMPDIR}/file.list;
    done < ${TMPDIR}/sources.txt;

    find ${LINEAGE_ROOT}/${OUTDIR} -type f -exec chmod 644 {} \;
}

#
# Handle patches
#
function do_patches() {
    for key in "${!PATCH_PATHS[@]}"; do
      source "${LINEAGE_ROOT}/device/nvidia/${PATCH_PATHS["$key"]}/extract/patches.sh";
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
        echo "Cleaning output directory ($OUTDIR).."
        rm -rf ${LINEAGE_ROOT}/${OUTDIR}/*
        VENDOR_STATE=1
    fi

    fetch_sources;
    copy_files;
    do_patches;
}
