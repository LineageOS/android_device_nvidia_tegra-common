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

LOCAL_PATH := $(call my-dir)
COMMON_PBC_PATH := ../../../../../vendor/nvidia/common/pbc

include $(CLEAR_VARS)
LOCAL_MODULE               := pbc2
LOCAL_SRC_FILES_32         := $(COMMON_PBC_PATH)/bin32/pbc2
LOCAL_SRC_FILES_64         := $(COMMON_PBC_PATH)/bin64/pbc2
LOCAL_MULTILIB             := first
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := pbc2.tegra
LOCAL_SRC_FILES_32         := $(COMMON_PBC_PATH)/lib/hw/pbc2.tegra.so
LOCAL_SRC_FILES_64         := $(COMMON_PBC_PATH)/lib64/hw/pbc2.tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)
