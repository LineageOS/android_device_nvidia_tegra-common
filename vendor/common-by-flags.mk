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

LOCAL_PATH := device/nvidia/tegra-common/vendor

ifneq ($(TARGET_TEGRA_DOLBY),)
include $(LOCAL_PATH)/ipprotect/ipprotect.mk
endif

ifeq ($(TARGET_TEGRA_AUDIO),nvaudio)
include $(LOCAL_PATH)/audio/audio.mk
endif

ifeq ($(TARGET_TEGRA_CAMERA),nvcamera)
include $(LOCAL_PATH)/camera/nvcamera.mk
endif

ifeq ($(NV_ANDROID_FRAMEWORK_ENHANCEMENTS),true)
include $(LOCAL_PATH)/nvcpl/nvcpl.mk
endif

ifeq ($(TARGET_TEGRA_GPU),nvgpu)
include $(LOCAL_PATH)/nvgpu/nvgpu.mk
endif

ifeq ($(TARGET_TEGRA_CEC),nvhdmi)
include $(LOCAL_PATH)/hdmi/hdmi.mk
endif

ifeq ($(TARGET_TEGRA_KEYSTORE),nvkeystore)
include $(LOCAL_PATH)/keystore/keystore.mk
include $(LOCAL_PATH)/security/security.mk
endif

ifeq ($(TARGET_TEGRA_MEMTRACK),nvmemtrack)
include $(LOCAL_PATH)/memtrack/memtrack.mk
endif

ifeq ($(TARGET_TEGRA_OMX),nvmm)
include $(LOCAL_PATH)/nvmm/nvmm.mk
endif

ifeq ($(TARGET_TEGRA_PHS),nvphs)
include $(LOCAL_PATH)/nvphs/nvphs.mk
endif

ifeq ($(TARGET_TEGRA_POWER),nvpower)
include $(LOCAL_PATH)/power/power.mk
endif

ifeq ($(TARGET_TEGRA_WIDEVINE),true)
include $(LOCAL_PATH)/widevine/widevine.mk
endif
