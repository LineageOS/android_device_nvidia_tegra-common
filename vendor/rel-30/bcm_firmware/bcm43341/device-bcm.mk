# Copyright (C) 2020 The LineageOS Project
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

COMMON_BCM_PATH := vendor/nvidia/common/rel-30/bcm_firmware

BCM_FW_SRC_FILE_STA := sdio-ag-pno-p2p-proptxstatus-dmatxrc-rxov-pktfilter-keepalive-aoe-sr-wapi-wl11d.bin

PRODUCT_COPY_FILES += \
    $(COMMON_BCM_PATH)/bcm43341/$(BCM_FW_SRC_FILE_STA):$(TARGET_COPY_OUT_VENDOR)/firmware/fw_bcmdhd.bin
