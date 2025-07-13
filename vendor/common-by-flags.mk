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
VENDOR_PATH := vendor/nvidia/common

PRODUCT_SOURCE_ROOT_DIRS += -$(LOCAL_PATH) -$(VENDOR_PATH)
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_DEFAULT_BRANCH)/common $(VENDOR_PATH)/$(TARGET_TEGRA_DEFAULT_BRANCH)/common

ifneq ($(TARGET_TEGRA_DOLBY),)
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_DEFAULT_BRANCH)/ipprotect $(VENDOR_PATH)/$(TARGET_TEGRA_DEFAULT_BRANCH)/ipprotect
$(call soong_config_set,TARGET_TEGRA,DOLBY,$(TARGET_TEGRA_DOLBY))
include $(LOCAL_PATH)/$(TARGET_TEGRA_DEFAULT_BRANCH)/ipprotect/ipprotect.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_AUDIO)/audio/audio.mk)","")
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_AUDIO)/audio $(VENDOR_PATH)/$(TARGET_TEGRA_AUDIO)/audio
ifneq ($(filter audio, $(TARGET_TEGRA_DOLBY)),)
PRODUCT_SOURCE_ROOT_DIRS += -$(VENDOR_PATH)/$(TARGET_TEGRA_AUDIO)/audio/nodolby
else
PRODUCT_SOURCE_ROOT_DIRS += -$(VENDOR_PATH)/$(TARGET_TEGRA_AUDIO)/audio/dolby
endif
ifeq ($(shell expr $(TARGET_TEGRA_MAN_LVL) \>= 6), 1)
$(call soong_config_set,TARGET_TEGRA,ST23,true)
endif
include $(LOCAL_PATH)/$(TARGET_TEGRA_AUDIO)/audio/audio.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_CAMERA)/camera/nvcamera.mk)","")
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_CAMERA)/camera $(VENDOR_PATH)/$(TARGET_TEGRA_CAMERA)/camera
include $(LOCAL_PATH)/$(TARGET_TEGRA_CAMERA)/camera/nvcamera.mk
endif

ifneq ($(NV_ANDROID_FRAMEWORK_ENHANCEMENTS),true)
TARGET_TEGRA_CPL :=
endif
ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_CPL)/nvcpl/nvcpl.mk)","")
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_CPL)/nvcpl $(VENDOR_PATH)/$(TARGET_TEGRA_CPL)/nvcpl
include $(LOCAL_PATH)/$(TARGET_TEGRA_DEFAULT_BRANCH)/nvcpl/nvcpl.mk
else
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/stubs/nvcpl
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_GPU)/nvgpu/nvgpu.mk)","")
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_GPU)/nvgpu $(VENDOR_PATH)/$(TARGET_TEGRA_GPU)/nvgpu
ifneq ($(filter video, $(TARGET_TEGRA_DOLBY)),)
PRODUCT_SOURCE_ROOT_DIRS += -$(VENDOR_PATH)/$(TARGET_TEGRA_GPU)/nvgpu/nodolby
else
PRODUCT_SOURCE_ROOT_DIRS += -$(VENDOR_PATH)/$(TARGET_TEGRA_GPU)/nvgpu/dolby $(LOCAL_PATH)/stubs/nvgpu
endif
include $(LOCAL_PATH)/$(TARGET_TEGRA_GPU)/nvgpu/nvgpu.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_CEC)/hdmi/hdmi.mk)","")
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_CEC)/hdmi $(VENDOR_PATH)/$(TARGET_TEGRA_CEC)/hdmi
include $(LOCAL_PATH)/$(TARGET_TEGRA_CEC)/hdmi/hdmi.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_MEMTRACK)/memtrack/memtrack.mk)","")
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_MEMTRACK)/memtrack $(VENDOR_PATH)/$(TARGET_TEGRA_MEMTRACK)/memtrack
include $(LOCAL_PATH)/$(TARGET_TEGRA_MEMTRACK)/memtrack/memtrack.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_OMX)/nvmm/nvmm.mk)","")
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_OMX)/nvmm $(VENDOR_PATH)/$(TARGET_TEGRA_OMX)/nvmm
ifneq ($(filter video, $(TARGET_TEGRA_DOLBY)),)
PRODUCT_SOURCE_ROOT_DIRS += -$(VENDOR_PATH)/$(TARGET_TEGRA_OMX)/nvmm/nodolby
else
PRODUCT_SOURCE_ROOT_DIRS += -$(VENDOR_PATH)/$(TARGET_TEGRA_OMX)/nvmm/dolby
endif
include $(LOCAL_PATH)/$(TARGET_TEGRA_OMX)/nvmm/nvmm.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_PMODEL)/nvpmodel/nvpmodel.mk)","")
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_PMODEL)/l4t $(VENDOR_PATH)/$(TARGET_TEGRA_PMODEL)/l4t
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_PMODEL)/nvpmodel $(VENDOR_PATH)/$(TARGET_TEGRA_PMODEL)/nvpmodel
include $(LOCAL_PATH)/$(TARGET_TEGRA_PMODEL)/nvpmodel/nvpmodel.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_PHS)/nvphs/nvphs.mk)","")
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_PHS)/nvphs $(VENDOR_PATH)/$(TARGET_TEGRA_PHS)/nvphs
include $(LOCAL_PATH)/$(TARGET_TEGRA_PHS)/nvphs/nvphs.mk
else
PRODUCT_SOURCE_ROOT_DIRS += -device/nvidia/tegra-common/nvphs $(LOCAL_PATH)/stubs/nvphs
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_POWER)/power/power.mk)","")
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_POWER)/power $(VENDOR_PATH)/$(TARGET_TEGRA_POWER)/power
include $(LOCAL_PATH)/$(TARGET_TEGRA_POWER)/power/power.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_TOS)/tos/tos.mk)","")
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_TOS)/tos $(VENDOR_PATH)/$(TARGET_TEGRA_TOS)/tos
include $(LOCAL_PATH)/$(TARGET_TEGRA_TOS)/tos/tos.mk
endif

ifneq ("$(wildcard $(LOCAL_PATH)/$(TARGET_TEGRA_WIDEVINE)/widevine/widevine.mk)","")
PRODUCT_SOURCE_ROOT_DIRS += $(LOCAL_PATH)/$(TARGET_TEGRA_WIDEVINE)/widevine $(VENDOR_PATH)/$(TARGET_TEGRA_WIDEVINE)/widevine
include $(LOCAL_PATH)/$(TARGET_TEGRA_WIDEVINE)/widevine/widevine.mk
endif

ifeq ($(TARGET_TEGRA_DEFAULT_BRANCH),rel-shield-r)
PRODUCT_PACKAGES += public.libraries
endif
