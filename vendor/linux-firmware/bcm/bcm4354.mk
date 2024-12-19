# Copyright (C) 2024 The LineageOS Project
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

COMMON_BCM_PATH := vendor/nvidia/common/rel-shield-r/bcm
LF_BCM_PATH := kernel/nvidia/linux-firmware/

PRODUCT_COPY_FILES += \
    $(LF_BCM_PATH)/cypress/cyfmac4354-sdio.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/brcm/brcmfmac4354-sdio.bin \
    $(LF_BCM_PATH)/cypress/cyfmac4354-sdio.clm_blob:$(TARGET_COPY_OUT_VENDOR)/firmware/brcm/brcmfmac4354-sdio.clm_blob \
    $(COMMON_BCM_PATH)/bcm4354/BCM4350C0.hcd:$(TARGET_COPY_OUT_VENDOR)/firmware/BCM4354.hcd
