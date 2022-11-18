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

# Purposefully unguarded, these are not available in working condition in any supported branch
LOCAL_PATH := $(call my-dir)
EXTERNAL_AUDIO_PATH := ../../../../../../vendor/nvidia/common/external/audio

include $(CLEAR_VARS)
LOCAL_MODULE               := libaptX_encoder
# 32-bit binary doesn't exist, but this needs to be here for parsing purposes
LOCAL_SRC_FILES_32         := $(EXTERNAL_AUDIO_PATH)/lib/libaptX_encoder.so
LOCAL_SRC_FILES_64         := $(EXTERNAL_AUDIO_PATH)/lib64/libaptX_encoder.so
LOCAL_MULTILIB             := first
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_SYSTEM_EXT_MODULE    := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libaptXHD_encoder
# 32-bit binary doesn't exist, but this needs to be here for parsing purposes
LOCAL_SRC_FILES_32         := $(EXTERNAL_AUDIO_PATH)/lib/libaptXHD_encoder.so
LOCAL_SRC_FILES_64         := $(EXTERNAL_AUDIO_PATH)/lib64/libaptXHD_encoder.so
LOCAL_MULTILIB             := first
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_SYSTEM_EXT_MODULE    := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)
