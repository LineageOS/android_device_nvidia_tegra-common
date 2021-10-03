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

# 32-bit nvgpu uses several intrinsics that got moved around in Q, so they need shimmed
function patch_nvgpu() {
  sed -i 's/liblog.so/libgol.so/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/egl/libEGL_tegra.so
  sed -i 's/liblog.so/libgol.so/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libglcore.so
  sed -i 's/liblog.so/libgol.so/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvglsi.so
  sed -i 's/liblog.so/libgol.so/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-fatbinaryloader.so
  sed -i 's/liblog.so/libgol.so/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-glvkspirv.so
  sed -i 's/liblog.so/libgol.so/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-ptxjitcompiler.so
  sed -i 's/liblog.so/libgol.so/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvrmapi_tegra.so

  sed -i 's/__aeabi_uldivmod/s_aeabi_uldivmod/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/egl/libEGL_tegra.so

  sed -i 's/__aeabi_ldivmod/s_aeabi_ldivmod/'   ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libglcore.so
  sed -i 's/__aeabi_uldivmod/s_aeabi_uldivmod/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libglcore.so

  sed -i 's/__aeabi_uldivmod/s_aeabi_uldivmod/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvglsi.so

  sed -i 's/__aeabi_ldivmod/s_aeabi_ldivmod/'   ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-fatbinaryloader.so
  sed -i 's/__aeabi_uldivmod/s_aeabi_uldivmod/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-fatbinaryloader.so

  sed -i 's/__aeabi_d2lz/s_aeabi_d2lz/'                     ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-glvkspirv.so
  sed -i 's/__aeabi_d2ulz/s_aeabi_d2ulz/'                   ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-glvkspirv.so
  sed -i 's/__aeabi_l2d/s_aeabi_l2d/'                       ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-glvkspirv.so
  sed -i 's/__aeabi_ul2d/s_aeabi_ul2d/'                     ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-glvkspirv.so
  sed -i 's/__aeabi_ldivmod/s_aeabi_ldivmod/'               ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-glvkspirv.so
  sed -i 's/__aeabi_uldivmod/s_aeabi_uldivmod/'             ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-glvkspirv.so
  sed -i 's/__aeabi_unwind_cpp_pr0/s_aeabi_unwind_cpp_pr0/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-glvkspirv.so
  sed -i 's/__aeabi_unwind_cpp_pr1/s_aeabi_unwind_cpp_pr1/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-glvkspirv.so

  sed -i 's/__aeabi_ldivmod/s_aeabi_ldivmod/'   ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-ptxjitcompiler.so
  sed -i 's/__aeabi_uldivmod/s_aeabi_uldivmod/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvidia-ptxjitcompiler.so

  sed -i 's/__aeabi_uldivmod/s_aeabi_uldivmod/' ${LINEAGE_ROOT}/${OUTDIR}/common/nvgpu/lib/libnvrmapi_tegra.so
}

# BUP tries to write the output file to cwd, let's instead use the already referenced env path var 'OUT'
function patch_bup() {
  sed -i 's/payload_obj.outfile/os.path.join(os.environ.get("OUT"), payload_obj.outfile)/' ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/BUP_generator.py
  sed -i "s/e\['outfile'\]/os.path.join\(out_path,e\['outfile'\]\)/" ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/nvblob_v2
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
patch_nvgpu;
patch_bup;
fetch_bmps;
