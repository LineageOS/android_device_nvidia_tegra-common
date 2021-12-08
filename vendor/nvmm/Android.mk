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
COMMON_NVMM_PATH := ../../../../../vendor/nvidia/common/nvmm

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvavp
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvavp.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvavp.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvmedia
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmedia.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvmedia.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvmm
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmm.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvmm.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvmm_audio
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmm_audio.so
LOCAL_MULTILIB             := 32
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvmm_contentpipe
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmm_contentpipe.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvmm_contentpipe.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvmm_msaudio
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmm_msaudio.so
LOCAL_MULTILIB             := 32
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvmm_parser
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmm_parser.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvmm_parser.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvmm_utils
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmm_utils.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvmm_utils.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvmm_writer
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmm_writer.so
LOCAL_MULTILIB             := 32
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvmmlite
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmmlite.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvmmlite.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvmmlite_audio
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmmlite_audio.so
LOCAL_MULTILIB             := 32
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvmmlite_image
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmmlite_image.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvmmlite_image.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvmmlite_msaudio
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmmlite_msaudio.so
LOCAL_MULTILIB             := 32
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvmmlite_utils
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmmlite_utils.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvmmlite_utils.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvmmlite_video
ifeq ($(TARGET_TEGRA_DOLBY),true)
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmmlite_video.dolby.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvmmlite_video.dolby.so
else
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvmmlite_video.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvmmlite_video.so
endif
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvomx
ifeq ($(TARGET_TEGRA_DOLBY),true)
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvomx.dolby.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvomx.dolby.so
else
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvomx.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvomx.so
endif
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_REQUIRED_MODULES     := libnvmm_parser libnvmmlite_image libnvmmlite_video
LOCAL_REQUIRED_MODULES_arm := libnvmm_audio libnvmm_msaudio libnvmm_writer libnvmmlite_audio libnvmmlite_msaudio
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvomxilclient
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvomxilclient.so
LOCAL_MULTILIB             := 32
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvparser
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvparser.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvparser.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libstagefrighthw
LOCAL_VINTF_FRAGMENTS      := android.hardware.media.omx@1.0-service.xml
ifeq ($(TARGET_TEGRA_DOLBY),true)
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libstagefrighthw.dolby.so
else
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libstagefrighthw.so
endif
LOCAL_MULTILIB             := 32
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvtnr
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvtnr.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvtnr.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvtvmr
LOCAL_SRC_FILES_32         := $(COMMON_NVMM_PATH)/lib/libnvtvmr.so
LOCAL_SRC_FILES_64         := $(COMMON_NVMM_PATH)/lib64/libnvtvmr.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)
