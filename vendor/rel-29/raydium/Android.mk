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

ifeq ($(TARGET_TEGRA_TOUCH),rel-29/raydium)
LOCAL_PATH := $(call my-dir)
COMMON_RAYDIUM_PATH := ../../../../../../vendor/nvidia/common/rel-29/raydium

# $1 Library name
# $2 Relative path
# $3 Required Modules
define rm_with_recovery_rule
include $(CLEAR_VARS)
LOCAL_MODULE               := $(strip $(1))
LOCAL_SRC_FILES_32         := $(COMMON_RAYDIUM_PATH)/lib/$(strip $(2))$(strip $(1)).so
LOCAL_MULTILIB             := 32
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := $(strip $(2))
LOCAL_REQUIRED_MODULES     := $(strip $(3))
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := $(strip $(1)).recovery
LOCAL_MODULE_STEM          := $(strip $(1))
LOCAL_SRC_FILES_32         := $(COMMON_RAYDIUM_PATH)/lib/$(strip $(2))$(strip $(1)).so
LOCAL_MULTILIB             := 32
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_MODULE_PATH          := $(TARGET_RECOVERY_ROOT_OUT)/system/lib/$(strip $(2))
LOCAL_REQUIRED_MODULES     := $(foreach mod,$(strip $(3)),$(mod).recovery)
include $(BUILD_NVIDIA_COMMON_PREBUILT)
endef

include $(CLEAR_VARS)
LOCAL_MODULE               := init.cal.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := initfiles/init.cal.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.ray_touch.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := initfiles/init.ray_touch.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.recovery.ray_touch.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := initfiles/init.recovery.ray_touch.rc
LOCAL_MODULE_PATH          := $(TARGET_RECOVERY_ROOT_OUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := touch.idc
LOCAL_SRC_FILES            := usr/idc/touch.idc
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/usr/idc
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := rm_ts_server
LOCAL_SRC_FILES_32         := $(COMMON_RAYDIUM_PATH)/bin32/rm_ts_server
LOCAL_MULTILIB             := 32
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := librm_ts_service
LOCAL_SRC_FILES_32         := $(COMMON_RAYDIUM_PATH)/lib/librm_ts_service.so
LOCAL_MULTILIB             := 32
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_SHARED_LIBRARIES     := liblog
include $(BUILD_NVIDIA_COMMON_PREBUILT)

$(eval $(call rm_with_recovery_rule, ts.default, hw/, librm31080 touch_para_10))
$(eval $(call rm_with_recovery_rule, librm31080, , para_10_02_00_a0 para_10_03_00_20 para_10_03_00_b0 para_10_04_00_c0 para_10_06_00_b0 para_10_08_00_20 para_10_08_00_b0 para_10_09_01_c0 para_10_0a_00_b0 para_10_02_00_20 para_10_02_00_b0 para_10_03_00_a0 para_10_04_00_b0 para_10_05_00_c0 para_10_07_00_b0 para_10_08_00_a0 para_10_09_00_c0 para_10_09_02_c0 para_10_0b_00_a0))
$(eval $(call rm_with_recovery_rule, para_10_02_00_a0))
$(eval $(call rm_with_recovery_rule, para_10_03_00_20))
$(eval $(call rm_with_recovery_rule, para_10_03_00_b0))
$(eval $(call rm_with_recovery_rule, para_10_04_00_c0))
$(eval $(call rm_with_recovery_rule, para_10_06_00_b0))
$(eval $(call rm_with_recovery_rule, para_10_08_00_20))
$(eval $(call rm_with_recovery_rule, para_10_08_00_b0))
$(eval $(call rm_with_recovery_rule, para_10_09_01_c0))
$(eval $(call rm_with_recovery_rule, para_10_0a_00_b0))
$(eval $(call rm_with_recovery_rule, para_10_02_00_20))
$(eval $(call rm_with_recovery_rule, para_10_02_00_b0))
$(eval $(call rm_with_recovery_rule, para_10_03_00_a0))
$(eval $(call rm_with_recovery_rule, para_10_04_00_b0))
$(eval $(call rm_with_recovery_rule, para_10_05_00_c0))
$(eval $(call rm_with_recovery_rule, para_10_07_00_b0))
$(eval $(call rm_with_recovery_rule, para_10_08_00_a0))
$(eval $(call rm_with_recovery_rule, para_10_09_00_c0))
$(eval $(call rm_with_recovery_rule, para_10_09_02_c0))
$(eval $(call rm_with_recovery_rule, para_10_0b_00_a0))
$(eval $(call rm_with_recovery_rule, touch_para_10))
endif
