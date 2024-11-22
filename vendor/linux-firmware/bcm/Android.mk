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

LOCAL_PATH := $(call my-dir)
LF_BCM_PATH := ../../../../../../kernel/nvidia/linux-firmware/

include $(CLEAR_VARS)
LOCAL_MODULE               := brcmfmac4354-sdio.bin
LOCAL_SRC_FILES            := $(LF_BCM_PATH)/cypress/cyfmac4354-sdio.bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/brcm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := cypress
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := brcmfmac4354-sdio.clm_blob
LOCAL_SRC_FILES            := $(LF_BCM_PATH)/cypress/cyfmac4354-sdio.clm_blob
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/brcm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := cypress
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := brcmfmac4356-pcie.bin
LOCAL_SRC_FILES            := $(LF_BCM_PATH)/cypress/cyfmac4356-pcie.bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/brcm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := cypress
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := brcmfmac4356-pcie.clm_blob
LOCAL_SRC_FILES            := $(LF_BCM_PATH)/cypress/cyfmac4356-pcie.clm_blob
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/brcm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := cypress
include $(BUILD_PREBUILT)
