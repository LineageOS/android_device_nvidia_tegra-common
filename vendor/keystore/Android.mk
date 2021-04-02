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
COMMON_KEYSTORE_PATH := ../../../../../vendor/nvidia/common/keystore

include $(CLEAR_VARS)
LOCAL_MODULE               := android.hardware.keymaster@3.0-service.tegra
LOCAL_VINTF_FRAGMENTS      := android.hardware.keymaster@3.0-service.xml
LOCAL_SRC_FILES_32         := $(COMMON_KEYSTORE_PATH)/bin32/hw/android.hardware.keymaster@3.0-service.tegra
LOCAL_SRC_FILES_64         := $(COMMON_KEYSTORE_PATH)/bin64/hw/android.hardware.keymaster@3.0-service.tegra
LOCAL_MULTILIB             := first
LOCAL_INIT_RC              := etc/init/android.hardware.keymaster@3.0-service.tegra.rc
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := gatekeeper.tlk.tegra
LOCAL_VINTF_FRAGMENTS      := android.hardware.gatekeeper@1.0-service.xml
LOCAL_SRC_FILES_32         := $(COMMON_KEYSTORE_PATH)/lib/hw/gatekeeper.tlk.tegra.so
LOCAL_SRC_FILES_64         := $(COMMON_KEYSTORE_PATH)/lib64/hw/gatekeeper.tlk.tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := gatekeeper.trusty.tegra
LOCAL_SRC_FILES_32         := $(COMMON_KEYSTORE_PATH)/lib/hw/gatekeeper.trusty.tegra.so
LOCAL_SRC_FILES_64         := $(COMMON_KEYSTORE_PATH)/lib64/hw/gatekeeper.trusty.tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := keystore.v0.tegra
LOCAL_SRC_FILES_32         := $(COMMON_KEYSTORE_PATH)/lib/hw/keystore.v0.tegra.so
LOCAL_SRC_FILES_64         := $(COMMON_KEYSTORE_PATH)/lib64/hw/keystore.v0.tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)
