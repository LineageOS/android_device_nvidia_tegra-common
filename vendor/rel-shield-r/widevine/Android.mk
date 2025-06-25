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

ifeq ($(TARGET_TEGRA_WIDEVINE),rel-shield-r)
LOCAL_PATH := $(call my-dir)
COMMON_WIDEVINE_PATH := ../../../../../../vendor/nvidia/common/rel-shield-r/widevine

include $(CLEAR_VARS)
LOCAL_MODULE               := android.hardware.drm@1.3-service.widevine
LOCAL_VINTF_FRAGMENTS      := widevine.xml
LOCAL_SRC_FILES_32         := $(COMMON_WIDEVINE_PATH)/bin32/hw/android.hardware.drm@1.3-service.widevine
LOCAL_MULTILIB             := 32
LOCAL_INIT_RC              := etc/init/android.hardware.drm@1.3-service.widevine.rc
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libwvhidl
LOCAL_SRC_FILES_32         := $(COMMON_WIDEVINE_PATH)/lib/libwvhidl.so
LOCAL_MULTILIB             := 32
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_SHARED_LIBRARIES     := android.hardware.drm@1.0 android.hardware.drm@1.1 android.hardware.drm@1.2 android.hardware.drm@1.3 android.hidl.memory@1.0 libbase libc++ libc libcrypto libdl libhidlbase libhidlmemory liblog libm libprotobuf-cpp-lite libutils libcrypto_shim
LOCAL_REQUIRED_MODULES     := libprotobuf-cpp-lite-3.9.1-vendorcompat
LOCAL_CHECK_ELF_FILES      := false
LOCAL_STRIP_MODULE         := false
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := liboemcrypto
LOCAL_SRC_FILES_32         := $(COMMON_WIDEVINE_PATH)/lib/liboemcrypto.so
LOCAL_MULTILIB             := 32
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)
endif
