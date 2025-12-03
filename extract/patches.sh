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

  mkdir -p ${LINEAGE_ROOT}/${OUTDIR}/common/external/bcm/bcm4356
  wget -q 'https://github.com/winterheart/broadcom-bt-firmware/raw/ddb24edc5169d064af3f405d6307aa4661a2cc52/brcm/BCM4356A2-13d3-3488.hcd' -O $(realpath ${LINEAGE_ROOT}/${OUTDIR}/common/external/bcm/bcm4356/BCM4356A2-13d3-3488.hcd)

  echo "";
}

# Needs to be run by the host
function chmod_tegraflash() {
  echo -n "Making tegraflash host binaries executable...";

  find ${LINEAGE_ROOT}/${OUTDIR}/common/r32/tegraflash -type f -exec chmod 755 {} \;
  find ${LINEAGE_ROOT}/${OUTDIR}/common/r35/tegraflash -type f -exec chmod 755 {} \;
  find ${LINEAGE_ROOT}/${OUTDIR}/common/r36/tegraflash -type f -exec chmod 755 {} \;
  find ${LINEAGE_ROOT}/${OUTDIR}/common/rel-24/tegraflash -type f -exec chmod 755 {} \;

  echo "";
}

# BUP tries to write the output file to cwd, let's instead use the already referenced env path var 'OUT'
# Since 32.6, BUP changed the version field format, however BMP blobs still require the previous version string
function patch_bup() {
  echo -n "Patching BUP...";

  sed -i 's/payload_obj.outfile/os.path.join(os.environ.get("OUT"), payload_obj.outfile)/' ${LINEAGE_ROOT}/${OUTDIR}/common/r35/tegraflash/BUP_generator.py
  sed -i 's/= bup_magic/= "NVIDIA__BLOB__V2" if args.blob_type == "bmp" else bup_magic/' ${LINEAGE_ROOT}/${OUTDIR}/common/r35/tegraflash/BUP_generator.py
  sed -i 's/self.gen_version/0x00020000 if args.blob_type == "bmp" else self.gen_version/' ${LINEAGE_ROOT}/${OUTDIR}/common/r35/tegraflash/BUP_generator.py

  sed -i 's/payload_obj.outfile/os.path.join(os.environ.get("OUT"), payload_obj.outfile)/' ${LINEAGE_ROOT}/${OUTDIR}/common/r36/tegraflash/BUP_generator.py
  sed -i 's/= bup_magic/= "NVIDIA__BLOB__V2" if args.blob_type == "bmp" else bup_magic/' ${LINEAGE_ROOT}/${OUTDIR}/common/r36/tegraflash/BUP_generator.py
  sed -i 's/self.gen_version/0x00020000 if args.blob_type == "bmp" else self.gen_version/' ${LINEAGE_ROOT}/${OUTDIR}/common/r36/tegraflash/BUP_generator.py

  echo "";
}

# tegrasign_v3 tries to write the output file to its local dir, let's instead write to cwd
# Remove dependency on yaml as it's not available in the aosp python prebuilts
function patch_tegrasign_v3() {
  echo -n "Patching tegrasign_v3...";

  sed -i "s|current_dir_path + '/|'|" ${LINEAGE_ROOT}/${OUTDIR}/common/r32/tegraflash/tegrasign_v3_internal.py
  sed -i "/current_dir_path/d" ${LINEAGE_ROOT}/${OUTDIR}/common/r32/tegraflash/tegrasign_v3_internal.py

  sed -i "s|current_dir_path + '/|'|" ${LINEAGE_ROOT}/${OUTDIR}/common/r35/tegraflash/tegrasign_v3_internal.py
  sed -i "/current_dir_path/d" ${LINEAGE_ROOT}/${OUTDIR}/common/r35/tegraflash/tegrasign_v3_internal.py

  sed -i "s|current_dir_path + '/|'|" ${LINEAGE_ROOT}/${OUTDIR}/common/r36/tegraflash/tegrasign_v3_internal.py
  sed -i "/current_dir_path/d" ${LINEAGE_ROOT}/${OUTDIR}/common/r36/tegraflash/tegrasign_v3_internal.py

  patch --no-backup-if-mismatch -d ${LINEAGE_ROOT}/${OUTDIR} -p1 1>/dev/null 2>&1 < ${LINEAGE_ROOT}/device/nvidia/tegra-common/extract/tegrasign.patch

  echo "";
}

# Tegraflash attempts to call dtbcheck in the current working directory
# Patch it to read from the same directory tegraflash is running from
function patch_tegraflash_dtbcheck() {
  patch --no-backup-if-mismatch -d ${LINEAGE_ROOT}/${OUTDIR}/common -p1 1>/dev/null 2>&1 < ${LINEAGE_ROOT}/device/nvidia/tegra-common/extract/tegraflash-dtbcheck.patch
}

# Some bootloader images need to be converted to BMP3
function convert_bmp() {
  # Thanks im7, for changing the established calling conventions
  CONVERT="convert";
  IDENTIFY="identify";
  if type magick &>/dev/null; then
    CONVERT="magick";
    IDENTIFY="magick identify";
  fi;
  if [ "$(${IDENTIFY} -format \"%m\" ${1})" != "\"BMP3\"" ]; then
    ${CONVERT} ${1} BMP3:${1};
  fi;
}
function convert_bmps() {
  echo -n "Converting bootloader BMPs to BMP3...";

  for bmp in ${LINEAGE_ROOT}/${OUTDIR}/common/rel-shield-r/BMP/*.bmp; do
    convert_bmp ${bmp};
  done;

  echo "";
}

function patch_tnspec() {
  echo -n "Patching tnspec python script to support python3...";

  patch --no-backup-if-mismatch -d ${LINEAGE_ROOT}/${OUTDIR} -p1 1>/dev/null 2>&1 < ${LINEAGE_ROOT}/device/nvidia/tegra-common/extract/tnspec-py3.patch

  echo "";
}

fetch_bcm4356_patchfile;
chmod_tegraflash;
patch_bup;
patch_tegrasign_v3;
patch_tegraflash_dtbcheck;
convert_bmps;
patch_tnspec;
