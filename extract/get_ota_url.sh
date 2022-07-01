#!/bin/bash

NVIDIA_OTA_QUERY_URL="https://ota.nvidia.com/ota/availableRom.php";

curl -s --get --data-urlencode "f=${1}" --data-urlencode "full_ota=1" ${NVIDIA_OTA_QUERY_URL} |jq -r '.data."0"."0"' |awk -F'|' '{ print $6 }';
