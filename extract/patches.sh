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
  wget 'https://github.com/winterheart/broadcom-bt-firmware/raw/ddb24edc5169d064af3f405d6307aa4661a2cc52/brcm/BCM4356A2-13d3-3488.hcd' -O ${LINEAGE_ROOT}/${OUTDIR}/common/bcm_firmware/bcm4356/BCM4356A2-13d3-3488.hcd
}

# Needs to be run by the host
function chmod_tegraflash() {
    find ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash -type f -exec chmod 755 {} \;
}

# Nvos is a vendor lib while nvcontrol_jni is a system lib, thus the build system errors due to treble rules.
# Nvos isn't actually used, so the lib can be replaced with any random thing that matches the length.
function patch_nvcontrol() {
  sed -i 's/libnvos.so/libjpeg.so/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvcpl/lib64/libnvcontrol_jni.so
  sed -i 's/libnvos.so/libjpeg.so/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvcpl/lib/libnvcontrol_jni.so
}

function patch_audio_msd() {
  sed -i 's/libjsoncpp.so/libjsonshm.so/' ${LINEAGE_ROOT}/${OUTDIR}/common/rel-shield-r/audio/bin32/hw/android.hardware.audio@6.0-service-msd
}

# BUP tries to write the output file to cwd, let's instead use the already referenced env path var 'OUT'
# Since 32.6, BUP changed the version field format, however BMP blobs still require the previous version string
function patch_bup() {
  sed -i 's/payload_obj.outfile/os.path.join(os.environ.get("OUT"), payload_obj.outfile)/' ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/BUP_generator.py
  sed -i "s/e\['outfile'\]/os.path.join\(out_path,e\['outfile'\]\)/" ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/nvblob_v2
  sed -i 's/= bup_magic/= "NVIDIA__BLOB__V2" if args.blob_type == "bmp" else bup_magic/' ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/BUP_generator.py
  sed -i 's/self.gen_version/0x00020000 if args.blob_type == "bmp" else self.gen_version/' ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/BUP_generator.py
}

# tegrasign_v3 tries to write the output file to its local dir, let's instead write to cwd
# Remove dependency on yaml as it's not available in the aosp python prebuilts
function patch_tegrasign_v3() {
  sed -i "s|current_dir_path + '/|'|" ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/tegrasign_v3_internal.py
  sed -i "/current_dir_path/d" ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/tegrasign_v3_internal.py

  patch --no-backup-if-mismatch -d ${LINEAGE_ROOT}/${OUTDIR} -p1 < ${LINEAGE_ROOT}/device/nvidia/tegra-common/extract/tegrasign.patch
}

# aptX libraries from stock t210 crash when opening an audio stream
# Source from Pixel 4 instead
function fetch_aptx() {
  FLAME_SYSTEM_EXT_URL="https://dumps.tadiphone.dev/dumps/google/flame/-/raw/flame-user-11-RQ2A.210305.006-7119741-release-keys/system_ext"
  mkdir -p ${LINEAGE_ROOT}/${OUTDIR}/common/audio/lib64
  wget ${FLAME_SYSTEM_EXT_URL}/lib64/libaptX_encoder.so -O ${LINEAGE_ROOT}/${OUTDIR}/common/audio/lib64/libaptX_encoder.so
  wget ${FLAME_SYSTEM_EXT_URL}/lib64/libaptXHD_encoder.so -O ${LINEAGE_ROOT}/${OUTDIR}/common/audio/lib64/libaptXHD_encoder.so
}

function fetch_l4t_deps() {
  mkdir -p ${LINEAGE_ROOT}/${OUTDIR}/common/l4t/bin64
  mkdir -p ${LINEAGE_ROOT}/${OUTDIR}/common/l4t/lib64
  LOCALTMPDIR=$(mktemp -d)
  pushd ${LOCALTMPDIR}
  wget http://ports.ubuntu.com/pool/main/g/glibc/libc6_2.31-0ubuntu9_arm64.deb
  ar x libc6_2.31-0ubuntu9_arm64.deb data.tar.xz
  tar -xf data.tar.xz ./lib/aarch64-linux-gnu/ld-2.31.so ./lib/aarch64-linux-gnu/libc-2.31.so
  cp lib/aarch64-linux-gnu/ld-2.31.so ${LINEAGE_ROOT}/${OUTDIR}/common/l4t/bin64/ld-linux-aarch64.so.1
  cp lib/aarch64-linux-gnu/libc-2.31.so ${LINEAGE_ROOT}/${OUTDIR}/common/l4t/lib64/libc.so.6
  popd
  rm -rf ${LOCALTMPDIR}
}

# Kludge l4t nvpmodel into running on android
function patch_nvpmodel() {
  mkdir -p ${LINEAGE_ROOT}/${OUTDIR}/common/nvpmodel/bin64
  LOCALTMPDIR=$(mktemp -d)
  pushd ${LOCALTMPDIR}
  ar x ${LINEAGE_ROOT}/${OUTDIR}/common/nvpmodel/nvidia-l4t-nvpmodel_arm64.deb data.tar.zst
  tar -xf data.tar.zst ./usr/sbin/nvpmodel
  cp usr/sbin/nvpmodel ${LINEAGE_ROOT}/${OUTDIR}/common/nvpmodel/bin64/nvpmodel
  popd
  rm -rf ${LOCALTMPDIR}
  rm ${LINEAGE_ROOT}/${OUTDIR}/common/nvpmodel/nvidia-l4t-nvpmodel_arm64.deb
  ${LINEAGE_ROOT}/prebuilts/extract-tools/linux-x86/bin/patchelf-0_9 --set-interpreter /vendor/bin/l4t/ld-linux-aarch64.so.1 ${LINEAGE_ROOT}/${OUTDIR}/common/nvpmodel/bin64/nvpmodel
  sed -i "s|/var/lib|/odm/etc|g" ${LINEAGE_ROOT}/${OUTDIR}/common/nvpmodel/bin64/nvpmodel
}

# Fetch bootloader logos and verity images from nv-tegra
function fetch_bmp() {
  NV_TEGRA_URL="https://nv-tegra.nvidia.com/r/plugins/gitiles/tegra/prebuilts-device-nvidia/+/refs/heads/rel-30-r2-partner/platform/t210/assets/bmp/"
  wget -qO- "${NV_TEGRA_URL}/${1}.bmp?format=TEXT" |base64 --decode > ${LINEAGE_ROOT}/${OUTDIR}/common/BMP/${1}.bmp
}
function fetch_bmps() {
  mkdir -p ${LINEAGE_ROOT}/${OUTDIR}/common/BMP
  fetch_bmp nvidia1080;
  fetch_bmp verity_orange_continue_1080;
  fetch_bmp verity_orange_pause_1080;
  fetch_bmp verity_red_continue_1080;
  fetch_bmp verity_red_pause_1080;
  fetch_bmp verity_yellow_continue_1080;
  fetch_bmp verity_yellow_pause_1080;
}

fetch_bcm4356_patchfile;
chmod_tegraflash;
patch_nvcontrol;
patch_audio_msd;
patch_bup;
patch_tegrasign_v3;
fetch_aptx;
fetch_l4t_deps;
patch_nvpmodel;
fetch_bmps;
