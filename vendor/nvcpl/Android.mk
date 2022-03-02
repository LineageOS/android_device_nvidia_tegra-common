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
COMMON_NVCPL_PATH := ../../../../../vendor/nvidia/common/nvcpl

include $(CLEAR_VARS)
LOCAL_MODULE               := NvCPLSvc
LOCAL_MODULE_TAGS          := optional
LOCAL_SRC_FILES            := $(COMMON_NVCPL_PATH)/app/NvCPLSvc/NvCPLSvc.apk
LOCAL_CERTIFICATE          := PRESIGNED
LOCAL_MODULE_CLASS         := APPS
LOCAL_MODULE_SUFFIX        := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_REQUIRED_MODULES     := libnvcontrol_jni
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vendor.nvidia.hardware.cpl.service@1.0-service
LOCAL_VINTF_FRAGMENTS      := vendor.nvidia.hardware.cpl.service@1.0-service.xml
LOCAL_SRC_FILES_32         := $(COMMON_NVCPL_PATH)/bin32/hw/vendor.nvidia.hardware.cpl.service@1.0-service
LOCAL_SRC_FILES_64         := $(COMMON_NVCPL_PATH)/bin64/hw/vendor.nvidia.hardware.cpl.service@1.0-service
LOCAL_MULTILIB             := first
LOCAL_INIT_RC              := etc/init/vendor.nvidia.hardware.cpl.service@1.0-service.rc
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vendor.nvidia.hardware.cpl.service_common@1.0-service
LOCAL_VINTF_FRAGMENTS      := vendor.nvidia.hardware.cpl.service_common@1.0-service.xml
LOCAL_SRC_FILES_32         := $(COMMON_NVCPL_PATH)/bin32/hw/vendor.nvidia.hardware.cpl.service_common@1.0-service
LOCAL_SRC_FILES_64         := $(COMMON_NVCPL_PATH)/bin64/hw/vendor.nvidia.hardware.cpl.service_common@1.0-service
LOCAL_MULTILIB             := first
LOCAL_INIT_RC              := etc/init/vendor.nvidia.hardware.cpl.service_common@1.0-service.rc
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvcpl_vendor
LOCAL_SRC_FILES_32         := $(COMMON_NVCPL_PATH)/lib/libnvcpl_vendor.so
LOCAL_SRC_FILES_64         := $(COMMON_NVCPL_PATH)/lib64/libnvcpl_vendor.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvcontrol_jni
LOCAL_SRC_FILES_32         := $(COMMON_NVCPL_PATH)/lib/libnvcontrol_jni.so
LOCAL_SRC_FILES_64         := $(COMMON_NVCPL_PATH)/lib64/libnvcontrol_jni.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
include $(BUILD_NVIDIA_COMMON_PREBUILT)
