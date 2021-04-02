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

ifeq ($(TARGET_TEGRA_POWER),nvpower)

LOCAL_PATH := $(call my-dir)
COMMON_POWER_PATH := ../../../../../vendor/nvidia/common/power

include $(CLEAR_VARS)
LOCAL_MODULE               := vendor.nvidia.hardware.power@1.0-service
LOCAL_VINTF_FRAGMENTS      := vendor.nvidia.hardware.power@1.0-service-nvpower.xml
LOCAL_SRC_FILES_32         := $(COMMON_POWER_PATH)/bin32/hw/vendor.nvidia.hardware.power@1.0-service
LOCAL_SRC_FILES_64         := $(COMMON_POWER_PATH)/bin64/hw/vendor.nvidia.hardware.power@1.0-service
LOCAL_MULTILIB             := first
LOCAL_INIT_RC              := etc/init/vendor.nvidia.hardware.power@1.0-service.rc
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_REQUIRED_MODULES     := powerhal.tegra
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := powerhal.tegra
LOCAL_SRC_FILES_32         := $(COMMON_POWER_PATH)/lib/hw/powerhal.tegra.so
LOCAL_SRC_FILES_64         := $(COMMON_POWER_PATH)/lib64/hw/powerhal.tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

endif
