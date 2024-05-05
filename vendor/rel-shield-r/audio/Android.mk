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

ifeq ($(TARGET_TEGRA_AUDIO),rel-shield-r)
LOCAL_PATH := $(call my-dir)
COMMON_AUDIO_PATH := ../../../../../../vendor/nvidia/common/rel-shield-r/audio
VNDK_30_PATH := ../../../../../../prebuilts/vndk/v30

include $(CLEAR_VARS)
LOCAL_MODULE               := NvAudioSvc
LOCAL_MODULE_TAGS          := optional
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/app/NvAudioSvc.apk
LOCAL_CERTIFICATE          := platform
LOCAL_MODULE_CLASS         := APPS
LOCAL_MODULE_SUFFIX        := $(COMMON_ANDROID_PACKAGE_SUFFIX)
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := DolbyAudioService
LOCAL_MODULE_TAGS          := optional
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/app/DolbyAudioService.apk
LOCAL_CERTIFICATE          := platform
LOCAL_MODULE_CLASS         := APPS
LOCAL_MODULE_SUFFIX        := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_REQUIRED_MODULES     := libnvcontrol_jni
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := android.hardware.audio@6.0-service-msd
LOCAL_SRC_FILES_32         := $(COMMON_AUDIO_PATH)/bin32/hw/android.hardware.audio@6.0-service-msd
LOCAL_MULTILIB             := 32
LOCAL_VINTF_FRAGMENTS      := android.hardware.audio.service.msd.xml
LOCAL_INIT_RC              := etc/init/android.hardware.audio@6.0-service-msd.rc
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_CHECK_ELF_FILES      := false
LOCAL_SHARED_LIBRARIES     := libcutils libhardware libhidlbase libhidltransport liblog libfmq libutils libmedia_helper libaudioutils vendor.nvidia.hardware.ipprotect@1.0 android.hardware.audio@6.0 android.hardware.audio.common@6.0 android.hardware.audio.common@6.0-util vendor.dolby.audio.measurement@1.0 vendor.dolby.ms12@1.0 vendor.dolby.ms12@1.1 vendor.dolby.ms12@1.2 libjsonshm libc++ libc libm libdl
LOCAL_REQUIRED_MODULES     := cp_pgm_one_dap_lib cp_pgm_two_dap_lib cp_sys_one_dap_lib cp_sys_two_dap_lib ddp_enc_lib_ac3 ddp_enc_lib_eac3 ddp_udc_lib_ac3 ddp_udc_lib_ec3 dp_dap_lib
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := audio.primary.tegra
ifneq ($(filter audio, $(TARGET_TEGRA_DOLBY)),)
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/hw/audio.primary.tegra.dolby.so
else
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/hw/audio.primary.tegra.so
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
ifeq ($(shell expr $(TARGET_TEGRA_MAN_LVL) \>= 6), 1)
LOCAL_VINTF_FRAGMENTS      := android.hardware.soundtrigger.23.xml
else
LOCAL_VINTF_FRAGMENTS      := android.hardware.soundtrigger.xml
endif
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
LOCAL_MODULE               := ddp_udc_lib_ac3
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/ddp_udc_lib_ac3.so
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH   := arm
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := ddp_udc_lib_ec3
LOCAL_SRC_FILES            := $(COMMON_AUDIO_PATH)/lib/ddp_udc_lib_ec3.so
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

include $(CLEAR_VARS)
LOCAL_MODULE               := libjsonshm
ifeq ($(TARGET_ARCH),arm64)
LOCAL_SRC_FILES_32         := $(VNDK_30_PATH)/arm64/arch-arm-armv8-a/shared/vndk-sp/libjsoncpp.so
LOCAL_SRC_FILES_64         := $(VNDK_30_PATH)/arm64/arch-arm64-armv8-a/shared/vndk-sp/libjsoncpp.so
else ifeq ($(TARGET_ARCH),arm)
LOCAL_SRC_FILES_32         := $(VNDK_30_PATH)/arm/arch-arm-armv7-a-neon/shared/vndk-sp/libjsoncpp.so
endif
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := google
LOCAL_VENDOR_MODULE        := true
LOCAL_CHECK_ELF_FILES      := false
include $(BUILD_NVIDIA_COMMON_PREBUILT)
endif
