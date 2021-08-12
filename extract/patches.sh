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
function patch_bup() {
  sed -i 's/payload_obj.outfile/os.path.join(os.environ.get("OUT"), payload_obj.outfile)/' ${LINEAGE_ROOT}/${OUTDIR}/common/tegraflash/BUP_generator.py
}

fetch_bcm4356_patchfile;
chmod_tegraflash;
patch_nvcontrol;
patch_bup;
