# Copyright (C) 2024 The LineageOS Project
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
LF_RTL_PATH := ../../../../../../kernel/nvidia/linux-firmware/

include $(CLEAR_VARS)
LOCAL_MODULE               := rtl8822cu_config-lf
LOCAL_MODULE_STEM          := rtl8822cu_config
LOCAL_SRC_FILES            := $(LF_RTL_PATH)/rtl_bt/rtl8761bu_config.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/rtl_bt
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := realtek
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := rtl8822cu_fw-lf
LOCAL_MODULE_STEM          := rtl8822cu_fw
LOCAL_SRC_FILES            := $(LF_RTL_PATH)/rtl_bt/rtl8822cu_fw.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/rtl_bt
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := realtek
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := rtw8822c_fw
LOCAL_SRC_FILES            := $(LF_RTL_PATH)/rtw88/rtw8822c_fw.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/rtw88
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := realtek
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := rtw8822c_wow_fw
LOCAL_SRC_FILES            := $(LF_RTL_PATH)/rtw88/rtw8822c_wow_fw.bin
LOCAL_MODULE_SUFFIX        := .bin
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/firmware/rtw88
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := realtek
include $(BUILD_PREBUILT)
