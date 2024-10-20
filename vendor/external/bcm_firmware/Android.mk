# Copyright (C) 2022 The LineageOS Project
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

# Purposefully unguarded, these are not available in any supported branch
LOCAL_PATH := $(call my-dir)
COMMON_BCM_PATH := ../../../../../../vendor/nvidia/common/external/bcm_firmware

include $(CLEAR_VARS)
LOCAL_MODULE               := BCM4356A2-13d3-3488
LOCAL_SRC_FILES            := $(COMMON_BCM_PATH)/bcm4356/BCM4356A2-13d3-3488.hcd
LOCAL_MODULE_SUFFIX        := .hcd
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/brcm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := broadcom
LOCAL_MODULE_SYMLINKS      := BCM4354A2-13d3-3488.hcd
include $(BUILD_NVIDIA_COMMON_PREBUILT)
