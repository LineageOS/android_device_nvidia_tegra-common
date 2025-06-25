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

ifeq ($(TARGET_TEGRA_TOS),rel-shield-r)
LOCAL_PATH := $(call my-dir)
COMMON_TOS_PATH := ../../../../../../vendor/nvidia/common/rel-shield-r/tos

include $(CLEAR_VARS)
LOCAL_MODULE               := android.hardware.keymaster@3.0-service.tegra
LOCAL_SRC_FILES_32         := $(COMMON_TOS_PATH)/bin32/hw/android.hardware.keymaster@3.0-service.tegra
LOCAL_SRC_FILES_64         := $(COMMON_TOS_PATH)/bin64/hw/android.hardware.keymaster@3.0-service.tegra
LOCAL_MULTILIB             := first
LOCAL_INIT_RC              := etc/init/android.hardware.keymaster@3.0-service.tegra.rc
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_SHARED_LIBRARIES     := libkeymaster_shim
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := run_ss_status
LOCAL_SRC_FILES            := $(COMMON_TOS_PATH)/bin/run_ss_status.sh
LOCAL_MODULE_SUFFIX        := .sh
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := eks2_client
LOCAL_SRC_FILES_32         := $(COMMON_TOS_PATH)/bin32/eks2_client
LOCAL_SRC_FILES_64         := $(COMMON_TOS_PATH)/bin64/eks2_client
LOCAL_MULTILIB             := first
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := ss_status
LOCAL_SRC_FILES_32         := $(COMMON_TOS_PATH)/bin32/ss_status
LOCAL_SRC_FILES_64         := $(COMMON_TOS_PATH)/bin64/ss_status
LOCAL_MULTILIB             := first
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := tlk_daemon
LOCAL_SRC_FILES_32         := $(COMMON_TOS_PATH)/bin32/tlk_daemon
LOCAL_SRC_FILES_64         := $(COMMON_TOS_PATH)/bin64/tlk_daemon
LOCAL_MULTILIB             := first
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := gatekeeper.tlk.tegra
LOCAL_SRC_FILES_32         := $(COMMON_TOS_PATH)/lib/hw/gatekeeper.tlk.tegra.so
LOCAL_SRC_FILES_64         := $(COMMON_TOS_PATH)/lib64/hw/gatekeeper.tlk.tegra.so
LOCAL_MULTILIB             := both
LOCAL_INIT_RC              := etc/init/android.hardware.gatekeeper@1.0-service.tegra.rc
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := keystore.v0.tegra
LOCAL_SRC_FILES_32         := $(COMMON_TOS_PATH)/lib/hw/keystore.v0.tegra.so
LOCAL_SRC_FILES_64         := $(COMMON_TOS_PATH)/lib64/hw/keystore.v0.tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)
endif
