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
COMMON_AUDIO_PATH := ../../../../../vendor/nvidia/common/audio

include $(CLEAR_VARS)
LOCAL_MODULE               := NvAudioSvc
LOCAL_MODULE_TAGS          := optional
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/app/NvAudioSvc.apk
LOCAL_CERTIFICATE          := PRESIGNED
LOCAL_MODULE_CLASS         := APPS
LOCAL_MODULE_SUFFIX        := $(COMMON_ANDROID_PACKAGE_SUFFIX)
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := DolbyAudioService
LOCAL_MODULE_TAGS          := optional
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/app/DolbyAudioService.apk
LOCAL_CERTIFICATE          := PRESIGNED
LOCAL_MODULE_CLASS         := APPS
LOCAL_MODULE_SUFFIX        := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_REQUIRED_MODULES     := libnvcontrol_jni
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := android.hardware.audio@4.0-service-msd
LOCAL_SRC_FILES_32         := $(COMMON_AUDIO_PATH)/bin32/hw/android.hardware.audio@4.0-service-msd
LOCAL_MULTILIB             := 32
LOCAL_INIT_RC              := etc/init/android.hardware.audio@4.0-service-msd.rc
LOCAL_VINTF_FRAGMENTS      := android.hardware.audio@4.0-service-msd.xml
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_REQUIRED_MODULES     := cp_pgm_one_dap_lib cp_pgm_two_dap_lib cp_sys_one_dap_lib cp_sys_two_dap_lib ddp_enc_lib_ac3 ddp_enc_lib_eac3 ddp_udc_lib dp_dap_lib
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := audio.primary.tegra
ifeq ($(TARGET_TEGRA_DOLBY),true)
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/hw/audio.primary.tegra.so
else
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/hw/audio.primary.tegra.nodolby.so
LOCAL_VINTF_FRAGMENTS      := android.hardware.audio@2.0-service.xml
endif
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_REQUIRED_MODULES     := libnvvisualizer
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := sound_trigger.primary.tegra
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/hw/sound_trigger.primary.tegra.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := cp_pgm_one_dap_lib
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/cp_pgm_one_dap_lib.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := cp_pgm_two_dap_lib
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/cp_pgm_two_dap_lib.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := cp_sys_one_dap_lib
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/cp_sys_one_dap_lib.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := cp_sys_two_dap_lib
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/cp_sys_two_dap_lib.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := ddp_enc_lib_ac3
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/ddp_enc_lib_ac3.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := ddp_enc_lib_eac3
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/ddp_enc_lib_eac3.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := dp_dap_lib
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/dp_dap_lib.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := ddp_udc_lib
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/ddp_udc_lib.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libim501
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/libim501.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvaudiofx
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/libnvaudiofx.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvoice
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/libnvoice.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vendor.dolby.ms12@1.0
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/vendor.dolby.ms12@1.0.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvvisualizer
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/soundfx/libnvvisualizer.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := soundfx
include $(BUILD_NVIDIA_COMMON_PREBUILT)
