# Copyright (C) 2021 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Used by btlinux
function fetch_bcm4356_patchfile() {
  echo -n "Fetching bcm4356 patchfile for btlinux from winterheart...";

  mkdir -p ${LINEAGE_ROOT}/${OUTDIR}/common/external/bcm_firmware/bcm4356
  wget -q 'https://github.com/winterheart/broadcom-bt-firmware/raw/ddb24edc5169d064af3f405d6307aa4661a2cc52/brcm/BCM4356A2-13d3-3488.hcd' -O ${LINEAGE_ROOT}/${OUTDIR}/common/external/bcm_firmware/bcm4356/BCM4356A2-13d3-3488.hcd

  echo "";
}

# Needs to be run by the host
function chmod_tegraflash() {
  echo -n "Making tegraflash host binaries executable...";

  find ${LINEAGE_ROOT}/${OUTDIR}/common/r35/tegraflash -type f -exec chmod 755 {} \;
  find ${LINEAGE_ROOT}/${OUTDIR}/common/rel-24/tegraflash -type f -exec chmod 755 {} \;

  echo "";
}

# Nvos is a vendor lib while nvcontrol_jni is a system lib, thus the build system errors due to treble rules.
# Nvos isn't actually used, so the lib can be replaced with any random thing that matches the length.
function patch_nvcontrol() {
  echo -n "Removing nvos reference from nvcpl jni...";

  sed -i 's/libnvos.so/libjpeg.so/' ${LINEAGE_ROOT}/${OUTDIR}/common/rel-shield-r/nvcpl/lib64/libnvcontrol_jni.so
  sed -i 's/libnvos.so/libjpeg.so/' ${LINEAGE_ROOT}/${OUTDIR}/common/rel-shield-r/nvcpl/lib/libnvcontrol_jni.so

  echo "";
}

function patch_audio_msd() {
  echo -n "Adding json shim to msd audio service...";

  sed -i 's/libjsoncpp.so/libjsonshm.so/' ${LINEAGE_ROOT}/${OUTDIR}/common/rel-shield-r/audio/bin32/hw/android.hardware.audio@6.0-service-msd

  echo "";
}

# BUP tries to write the output file to cwd, let's instead use the already referenced env path var 'OUT'
# Since 32.6, BUP changed the version field format, however BMP blobs still require the previous version string
function patch_bup() {
  echo -n "Patching BUP...";

  sed -i 's/payload_obj.outfile/os.path.join(os.environ.get("OUT"), payload_obj.outfile)/' ${LINEAGE_ROOT}/${OUTDIR}/common/r35/tegraflash/BUP_generator.py
  sed -i 's/= bup_magic/= "NVIDIA__BLOB__V2" if args.blob_type == "bmp" else bup_magic/' ${LINEAGE_ROOT}/${OUTDIR}/common/r35/tegraflash/BUP_generator.py
  sed -i 's/self.gen_version/0x00020000 if args.blob_type == "bmp" else self.gen_version/' ${LINEAGE_ROOT}/${OUTDIR}/common/r35/tegraflash/BUP_generator.py

  echo "";
}

# tegrasign_v3 tries to write the output file to its local dir, let's instead write to cwd
# Remove dependency on yaml as it's not available in the aosp python prebuilts
function patch_tegrasign_v3() {
  echo -n "Patching tegrasign_v3...";

  sed -i "s|current_dir_path + '/|'|" ${LINEAGE_ROOT}/${OUTDIR}/common/r35/tegraflash/tegrasign_v3_internal.py
  sed -i "/current_dir_path/d" ${LINEAGE_ROOT}/${OUTDIR}/common/r35/tegraflash/tegrasign_v3_internal.py

  patch --no-backup-if-mismatch -d ${LINEAGE_ROOT}/${OUTDIR} -p1 1>/dev/null 2>&1 < ${LINEAGE_ROOT}/device/nvidia/tegra-common/extract/tegrasign.patch

  echo "";
}

# Tegraflash attempts to call dtbcheck in the current working directory
# Patch it to read from the same directory tegraflash is running from
function patch_tegraflash_dtbcheck() {
  patch --no-backup-if-mismatch -d ${LINEAGE_ROOT}/${OUTDIR}/common -p1 < ${LINEAGE_ROOT}/device/nvidia/tegra-common/extract/tegraflash-dtbcheck.patch
}

function fetch_l4t_deps() {
  echo -n "Fetching dependencies for nvpmodel...";

  mkdir -p ${LINEAGE_ROOT}/${OUTDIR}/common/r35/l4t/bin64
  mkdir -p ${LINEAGE_ROOT}/${OUTDIR}/common/r35/l4t/lib64
  LOCALTMPDIR=$(mktemp -d)
  pushd ${LOCALTMPDIR} 1>/dev/null 2>&1
  wget -q http://ports.ubuntu.com/pool/main/g/glibc/libc6_2.31-0ubuntu9_arm64.deb
  ar x libc6_2.31-0ubuntu9_arm64.deb data.tar.xz 1>/dev/null 2>&1
  tar -xf data.tar.xz ./lib/aarch64-linux-gnu/ld-2.31.so ./lib/aarch64-linux-gnu/libc-2.31.so ./lib/aarch64-linux-gnu/libdl-2.31.so ./lib/aarch64-linux-gnu/librt-2.31.so ./lib/aarch64-linux-gnu/libpthread-2.31.so 1>/dev/null 2>&1
  cp lib/aarch64-linux-gnu/ld-2.31.so ${LINEAGE_ROOT}/${OUTDIR}/common/r35/l4t/bin64/ld-linux-aarch64.so.1
  cp lib/aarch64-linux-gnu/libc-2.31.so ${LINEAGE_ROOT}/${OUTDIR}/common/r35/l4t/lib64/libc.so.6
  cp lib/aarch64-linux-gnu//libdl-2.31.so ${LINEAGE_ROOT}/${OUTDIR}/common/r35/l4t/lib64/libdl.so.2
  cp lib/aarch64-linux-gnu/librt-2.31.so ${LINEAGE_ROOT}/${OUTDIR}/common/r35/l4t/lib64/librt.so.1
  cp lib/aarch64-linux-gnu/libpthread-2.31.so ${LINEAGE_ROOT}/${OUTDIR}/common/r35/l4t/lib64/libpthread.so.0
  popd 1>/dev/null 2>&1
  rm -rf ${LOCALTMPDIR}

  echo "";
}

# Kludge l4t nvpmodel into running on android
function patch_nvpmodel() {
  echo -n "Setting up nvpmodel...";

  mkdir -p ${LINEAGE_ROOT}/${OUTDIR}/common/r35/nvpmodel/bin64
  LOCALTMPDIR=$(mktemp -d)
  pushd ${LOCALTMPDIR} 1>/dev/null 2>&1
  ar x ${LINEAGE_ROOT}/${OUTDIR}/common/r35/nvpmodel/nvidia-l4t-nvpmodel_arm64.deb data.tar.zst 2>&1 1>/dev/null
  tar -xf data.tar.zst ./usr/sbin/nvpmodel 1>/dev/null 2>&1
  cp usr/sbin/nvpmodel ${LINEAGE_ROOT}/${OUTDIR}/common/r35/nvpmodel/bin64/nvpmodel
  popd 1>/dev/null 2>&1
  rm -rf ${LOCALTMPDIR}
  rm ${LINEAGE_ROOT}/${OUTDIR}/common/r35/nvpmodel/nvidia-l4t-nvpmodel_arm64.deb
  ${LINEAGE_ROOT}/prebuilts/extract-tools/linux-x86/bin/patchelf-0_9 --set-interpreter /vendor/bin/l4t/ld-linux-aarch64.so.1 ${LINEAGE_ROOT}/${OUTDIR}/common/r35/nvpmodel/bin64/nvpmodel 1>/dev/null 2>&1
  sed -i "s|/var/lib|/odm/etc|g" ${LINEAGE_ROOT}/${OUTDIR}/common/r35/nvpmodel/bin64/nvpmodel

  echo "";
}

# Fetch bootloader logos and verity images from nv-tegra
function fetch_bmp() {
  NV_TEGRA_URL="https://nv-tegra.nvidia.com/r/plugins/gitiles/tegra/prebuilts-device-nvidia/+/refs/heads/rel-30-r2-partner/platform/t210/assets/bmp/"
  wget -qO- "${NV_TEGRA_URL}/${1}.bmp?format=TEXT" |base64 --decode > ${LINEAGE_ROOT}/${OUTDIR}/common/rel-30/BMP/${1}.bmp
}
function fetch_bmps() {
  echo -n "Fetching bootloader BMPs from nv-tegra...";

  mkdir -p ${LINEAGE_ROOT}/${OUTDIR}/common/rel-30/BMP
  fetch_bmp nvidia1080;
  fetch_bmp verity_orange_continue_1080;
  fetch_bmp verity_orange_pause_1080;
  fetch_bmp verity_red_continue_1080;
  fetch_bmp verity_red_pause_1080;
  fetch_bmp verity_yellow_continue_1080;
  fetch_bmp verity_yellow_pause_1080;

  echo "";
}

fetch_bcm4356_patchfile;
chmod_tegraflash;
patch_nvcontrol;
patch_audio_msd;
patch_bup;
patch_tegrasign_v3;
patch_tegraflash_dtbcheck;
fetch_l4t_deps;
patch_nvpmodel;
fetch_bmps;
