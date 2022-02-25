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

LOCAL_PATH := $(call my-dir)
COMMON_L4T_PATH := ../../../../../vendor/nvidia/common/l4t

include $(CLEAR_VARS)
LOCAL_MODULE               := ld-linux-aarch64.so.1
LOCAL_SRC_FILES            := $(COMMON_L4T_PATH)/bin64/ld-linux-aarch64.so.1
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TARGET_ARCH   := arm64
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := gnu
LOCAL_VENDOR_MODULE        := true
LOCAL_CHECK_ELF_FILES      := false
LOCAL_MODULE_RELATIVE_PATH := l4t
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libc.so.6
LOCAL_SRC_FILES            := $(COMMON_L4T_PATH)/lib64/libc.so.6
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm64
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := gnu
LOCAL_VENDOR_MODULE        := true
LOCAL_CHECK_ELF_FILES      := false
LOCAL_MODULE_RELATIVE_PATH := l4t
include $(BUILD_PREBUILT)
