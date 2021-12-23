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

# BUP tries to write the output file to cwd, let's instead use the already referenced env path var 'OUT'
# Since 32.6, BUP changed the version field format, however BMP blobs still require the previous version string
function patch_bup() {
  sed -i 's/payload_obj.outfile/os.path.join(os.environ.get("OUT"), payload_obj.outfile)/' ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/BUP_generator.py
  sed -i "s/e\['outfile'\]/os.path.join\(out_path,e\['outfile'\]\)/" ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/nvblob_v2
  sed -i 's/self.gen_version/0x00020000 if args.blob_type == "bmp" else self.gen_version/' ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/BUP_generator.py
}

# Tegraflash does a few invalid comparisons, caught by newer versions of py3
function patch_tegraflash() {
  sed -i 's/if sig_type is not "zerosbk"/if sig_type != "zerosbk"/' ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/tegraflash_internal.py
  sed -i 's/if sig_type is "oem-rsa"/if sig_type == "oem-rsa"/' ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/tegraflash_internal.py
  sed -i 's/while count is not 0/while count != 0/' ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/tegraflash_internal.py
}

# tegrasign_v3 tries to write the output file to its local dir, let's instead write to cwd
function patch_tegrasign_v3() {
  sed -i "s|current_dir_path + '/|'|" ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/tegrasign_v3_internal.py
  sed -i "/current_dir_path/d" ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/tegrasign_v3_internal.py
}

# 64-bit aptX libraries have wrong soname
function patch_aptx() {
  ${LINEAGE_ROOT}/prebuilts/extract-tools/linux-x86/bin/patchelf-0_9 --set-soname libaptX_encoder.so ${LINEAGE_ROOT}/${OUTDIR}/common/audio/lib64/libaptX_encoder.so
  ${LINEAGE_ROOT}/prebuilts/extract-tools/linux-x86/bin/patchelf-0_9 --set-soname libaptXHD_encoder.so ${LINEAGE_ROOT}/${OUTDIR}/common/audio/lib64/libaptXHD_encoder.so
}

# Fetch bootloader logos and verity images from nv-tegra
function fetch_bmps() {
  NV_TEGRA_URL="https://nv-tegra.nvidia.com/gitweb/?p=tegra/prebuilts-device-nvidia.git;hb=rel-30-r2-partner;a=blob;f=platform/t210/assets/bmp"
  mkdir -p ${LINEAGE_ROOT}/${OUTDIR}/common/BMP
  wget ${NV_TEGRA_URL}/nvidia1080.bmp -O ${LINEAGE_ROOT}/${OUTDIR}/common/BMP/nvidia1080.bmp
  wget ${NV_TEGRA_URL}/verity_orange_continue_1080.bmp -O ${LINEAGE_ROOT}/${OUTDIR}/common/BMP/verity_orange_continue_1080.bmp
  wget ${NV_TEGRA_URL}/verity_orange_pause_1080.bmp -O ${LINEAGE_ROOT}/${OUTDIR}/common/BMP/verity_orange_pause_1080.bmp
  wget ${NV_TEGRA_URL}/verity_red_continue_1080.bmp -O ${LINEAGE_ROOT}/${OUTDIR}/common/BMP/verity_red_continue_1080.bmp
  wget ${NV_TEGRA_URL}/verity_red_pause_1080.bmp -O ${LINEAGE_ROOT}/${OUTDIR}/common/BMP/verity_red_pause_1080.bmp
  wget ${NV_TEGRA_URL}/verity_yellow_continue_1080.bmp -O ${LINEAGE_ROOT}/${OUTDIR}/common/BMP/verity_yellow_continue_1080.bmp
  wget ${NV_TEGRA_URL}/verity_yellow_pause_1080.bmp -O ${LINEAGE_ROOT}/${OUTDIR}/common/BMP/verity_yellow_pause_1080.bmp
}

fetch_bcm4356_patchfile;
chmod_tegraflash;
patch_nvcontrol;
patch_bup;
patch_tegraflash;
patch_tegrasign_v3;
patch_aptx;
fetch_bmps;
