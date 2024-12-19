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

PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)/$(TARGET_TEGRA_L4T_BRANCH)

ifneq ($(TARGET_TEGRA_DOLBY),)
include $(LOCAL_PATH)/$(TARGET_TEGRA_DEFAULT_BRANCH)/ipprotect/ipprotect.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_AUDIO)/audio/audio.mk)","")
include $(LOCAL_PATH)/$(TARGET_TEGRA_AUDIO)/audio/audio.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_CAMERA)/camera/nvcamera.mk)","")
include $(LOCAL_PATH)/$(TARGET_TEGRA_CAMERA)/camera/nvcamera.mk
endif

ifeq ($(NV_ANDROID_FRAMEWORK_ENHANCEMENTS),true)
ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_DEFAULT_BRANCH)/nvcpl/nvcpl.mk)","")
include $(LOCAL_PATH)/$(TARGET_TEGRA_DEFAULT_BRANCH)/nvcpl/nvcpl.mk
endif
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_GPU)/nvgpu/nvgpu.mk)","")
include $(LOCAL_PATH)/$(TARGET_TEGRA_GPU)/nvgpu/nvgpu.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_CEC)/hdmi/hdmi.mk)","")
include $(LOCAL_PATH)/$(TARGET_TEGRA_CEC)/hdmi/hdmi.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_MEMTRACK)/memtrack/memtrack.mk)","")
include $(LOCAL_PATH)/$(TARGET_TEGRA_MEMTRACK)/memtrack/memtrack.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_OMX)/nvmm/nvmm.mk)","")
include $(LOCAL_PATH)/$(TARGET_TEGRA_OMX)/nvmm/nvmm.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_PHS)/nvphs/nvphs.mk)","")
include $(LOCAL_PATH)/$(TARGET_TEGRA_PHS)/nvphs/nvphs.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_POWER)/power/power.mk)","")
include $(LOCAL_PATH)/$(TARGET_TEGRA_POWER)/power/power.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_TOS)/tos/tos.mk)","")
include $(LOCAL_PATH)/$(TARGET_TEGRA_TOS)/tos/tos.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_WIDEVINE)/widevine/widevine.mk)","")
include $(LOCAL_PATH)/$(TARGET_TEGRA_WIDEVINE)/widevine/widevine.mk
endif

ifeq ($(TARGET_TEGRA_DEFAULT_BRANCH),rel-shield-r)
PRODUCT_PACKAGES += public.libraries
endif
