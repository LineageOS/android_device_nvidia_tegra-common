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

ifeq ($(TARGET_TEGRA_L4T_BRANCH),r35)
LOCAL_PATH := $(call my-dir)
COMMON_NVPMODEL_PATH := ../../../../../../vendor/nvidia/common/r35/nvpmodel

include $(CLEAR_VARS)
LOCAL_MODULE               := nvpmodel
LOCAL_SRC_FILES            := $(COMMON_NVPMODEL_PATH)/bin64/nvpmodel
LOCAL_INIT_RC              := etc/init/nvpmodel.rc
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TARGET_ARCH   := arm64
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_REQUIRED_MODULES     := ld-linux-aarch64.so.1 libc.so.6 libnvsocsys-l4t nvpmodel_script
LOCAL_CHECK_ELF_FILES      := false
LOCAL_MODULE_RELATIVE_PATH := l4t
LOCAL_REQUIRED_MODULES     := nvpmodel_symlink
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := nvpmodel_script
LOCAL_MODULE_STEM   := nvpmodel
LOCAL_SRC_FILES     := bin/nvpmodel.sh
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_MODULE_OWNER  := lineage
LOCAL_VENDOR_MODULE := true
include $(BUILD_PREBUILT)
endif
