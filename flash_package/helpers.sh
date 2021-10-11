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

declare -A APXPRODUCT;
APXPRODUCT[t210]=7721;
APXPRODUCT[t210nano]=7f21;
APXPRODUCT[t186]=7c18;
APXPRODUCT[t194]=7019;
APXPRODUCT[t194nx]=7e19;

declare AVAILABLE_INTERFACES=();
declare INTERFACE;

declare -A MODULEINFO;
declare -A CARRIERINFO;

# Get list of devices in apx mode for the given tegra version
function get_interfaces()
{
  shopt -s globstar
  for devnumpath in /sys/bus/usb/devices/usb*/**/devnum; do
    if [ "$(cat $(dirname ${devnumpath})/idVendor)"  == "0955" ] &&
       [ "$(cat $(dirname ${devnumpath})/idProduct)" == "${APXPRODUCT[${TARGET_TEGRA_VERSION}]}" ]; then
      AVAILABLE_INTERFACES+="$(cat $(dirname ${devnumpath})/busnum)-$(cat $(dirname ${devnumpath})/devpath)";
      break;
    fi;
  done;

  if [ ${#AVAILABLE_INTERFACES[@]} -eq 0 ]; then
    echo "No ${TARGET_TEGRA_VERSION} devices in RCM mode found";
    return -1;
  fi;

  return 0;
}

# Get board info from the module eeprom
function get_moduleinfo()
{
  MODCMD=
  if [ "${TARGET_TEGRA_VERSION}" == "t210" -o "${TARGET_TEGRA_VERSION}" == "t210nano" ]; then
    MODCMD="dump eeprom boardinfo eeprom_boardinfo.bin";
  else
    MODCMD="dump eeprom boardinfo eeprom_boardinfo.bin; reboot recovery";
  fi;

  tegraflash.py \
    "${FLASH_CMD_BASIC[@]}" \
    --instance ${INTERFACE} \
    --cmd "${MODCMD}" \
    > /dev/null;

  if [ ! -f eeprom_boardinfo.bin ]; then
    MODULEINFO[boardid]="";
    return;
  fi;

  MODULEINFO[assetnum]=$(dd if=eeprom_boardinfo.bin bs=1 skip=74 count=15 status=none |tr -dc '[[:print:]]');
  MODULEINFO[boardid]=$((16#$(dd if=eeprom_boardinfo.bin bs=1 skip=4 count=2 status=none |xxd -p |tac -rs .. |tr -d '\n')));
  MODULEINFO[sku]=$((16#$(dd if=eeprom_boardinfo.bin bs=1 skip=6 count=2 status=none |xxd -p |tac -rs .. |tr -d '\n')));
  MODULEINFO[fab]=$((16#$(dd if=eeprom_boardinfo.bin bs=1 skip=8 count=1 status=none |xxd -p)));
  MODULEINFO[revmaj]=$((16#$(dd if=eeprom_boardinfo.bin bs=1 skip=9 count=1 status=none |xxd -p)));
  MODULEINFO[revmin]=$((16#$(dd if=eeprom_boardinfo.bin bs=1 skip=10 count=1 status=none |xxd -p)));
  MODULEINFO[version]=$(dd if=eeprom_boardinfo.bin bs=1 skip=35 count=3 status=none);

  rm eeprom_boardinfo.bin;
}

# Get board info from the carrier board eeprom
# This functionality is not available from tegraflash on t210
function get_carrierinfo()
{
  if [ "${TARGET_TEGRA_VERSION}" == "t210" -o "${TARGET_TEGRA_VERSION}" == "t210nano" ]; then
    return 0;
  fi;

  tegraflash.py \
    "${FLASH_CMD_FULL[@]}" \
    --instance ${INTERFACE} \
    --cmd "dump eeprom baseinfo eeprom_baseinfo.bin; reboot recovery" \
    > /dev/null;

  if [ ! -f eeprom_baseinfo.bin ]; then
    CARRIERINFO[boardid]="";
    return;
  fi;

  CARRIERINFO[assetnum]=$(dd if=eeprom_baseinfo.bin bs=1 skip=74 count=15 status=none |tr -dc '[[:print:]]');
  CARRIERINFO[boardid]=$((16#$(dd if=eeprom_baseinfo.bin bs=1 skip=4 count=2 status=none |xxd -p |tac -rs .. |tr -d '\n')));
  CARRIERINFO[sku]=$((16#$(dd if=eeprom_baseinfo.bin bs=1 skip=6 count=2 status=none |xxd -p |tac -rs .. |tr -d '\n')));
  CARRIERINFO[fab]=$((16#$(dd if=eeprom_baseinfo.bin bs=1 skip=8 count=1 status=none |xxd -p)));
  CARRIERINFO[revmaj]=$((16#$(dd if=eeprom_baseinfo.bin bs=1 skip=9 count=1 status=none |xxd -p)));
  CARRIERINFO[revmin]=$((16#$(dd if=eeprom_baseinfo.bin bs=1 skip=10 count=1 status=none |xxd -p)));
  CARRIERINFO[version]=$(dd if=eeprom_carrierinfo.bin bs=1 skip=35 count=3 status=none);

  rm eeprom_baseinfo.bin;
}

# Find device matching given module board id.
function check_module_compatibility()
{
  local MODULEID=${1};
  local TEMPVERSION=;

  echo "Checking module compatibility.";

  declare -A INTERFACES_COPY;
  for key in "${!AVAILABLE_INTERFACES[@]}"; do
    INTERFACES_COPY["$key"]="${AVAILABLE_INTERFACES["$key"]}";
  done;

  for intfnum in "${!INTERFACES_COPY[@]}"; do
    INTERFACE=${INTERFACES_COPY[$intfnum]};
    get_moduleinfo;
    unset 'INTERFACE'

    if [ "${MODULEINFO[boardid]}" = "${MODULEID}" ]; then
      if [ -z ${TEMPVERSION} ]; then
        TEMPVERSION="${MODULEINFO[version]}";
      elif [ "${MODULEINFO[version]}" != "${TEMPVERSION}" ]; then
        echo "Multiple devices with incompatible module versions found in RCM mode. Please disconnect one and try again.";
        return -1;
      fi;
    else
      unset "AVAILABLE_INTERFACES[$intfnum]";
    fi;
  done;

  if [ ${#AVAILABLE_INTERFACES[@]} -eq 0 ]; then
    echo "No compatible devices found.";
    return -1;
  fi;

  return 0;
}

# Find device matching given carrier board id.
function check_carrier_compatibility()
{
  local CARRIERID=${1};

  if [ "${TARGET_TEGRA_VERSION}" != "t210" -o "${TARGET_TEGRA_VERSION}" != "t210nano" ] &&
     [ -n "${CARRIERID}" ]; then
    echo "Checking carrier board compatibility.";

    declare -A INTERFACES_COPY;
    for key in "${!AVAILABLE_INTERFACES[@]}"; do
      INTERFACES_COPY["$key"]="${AVAILABLE_INTERFACES["$key"]}";
    done;

    for intfnum in "${!INTERFACES_COPY[@]}"; do
      INTERFACE=${INTERFACES_COPY[$intfnum]};
      get_carrierinfo;
      unset 'INTERFACE'

      if [ "${CARRIERINFO[boardid]}" != "${CARRIERID}" ]; then
        unset "AVAILABLE_INTERFACES[$intfnum]";
      fi;
    done;
  else
    echo "Checking carrier board info not supported. Continuing assuming success.";
  fi;

  if [ ${#AVAILABLE_INTERFACES[@]} -eq 0 ]; then
    echo "No compatible devices found.";
    return -1;
  fi;

  if [ ${#AVAILABLE_INTERFACES[@]} -ge 2 ]; then
    echo "Multiple compatible devices found. Please disconnect all but one and try again.";
    return -1;
  fi;

  INTERFACE="${AVAILABLE_INTERFACES[0]}";
  return 0;
}
