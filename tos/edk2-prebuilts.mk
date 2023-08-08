#
# Copyright (C) 2023 The LineageOS Project
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
#

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE        := tianocore
LOCAL_MODULE_SUFFIX := .bin
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_SRC_FILES     := tianocore/tianocore.bin
LOCAL_MODULE_PATH   := $(PRODUCT_OUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := AndroidConfiguration
LOCAL_MODULE_SUFFIX := .dtbo
LOCAL_MODULE_CLASS  := ETC
LOCAL_SRC_FILES     := tianocore/AndroidConfiguration.dtbo
LOCAL_MODULE_PATH   := $(PRODUCT_OUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := AndroidLauncher
LOCAL_MODULE_SUFFIX        := .efi
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_SRC_FILES            := tianocore/AndroidLauncher.efi
LOCAL_MODULE_RELATIVE_PATH := firmware
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := AndroidLauncher-recovery
LOCAL_MODULE_SUFFIX := .efi
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_SRC_FILES     := tianocore/AndroidLauncher-recovery.efi
LOCAL_MODULE_PATH   := $(PRODUCT_OUT)
include $(BUILD_PREBUILT)
