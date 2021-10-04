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

UBOOT_PATH := external/u-boot

include $(CLEAR_VARS)

LOCAL_MODULE        := u-boot-tegra
LOCAL_MODULE_SUFFIX := .bin
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_MODULE_PATH   := $(PRODUCT_OUT)

_uboot_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))
_uboot_bin := $(_uboot_intermediates)/$(LOCAL_MODULE)$(LOCAL_MODULE_SUFFIX)

$(_uboot_bin):
	@mkdir -p $(dir $@)
	$(hide) +$(KERNEL_MAKE_CMD) $(KERNEL_CROSS_COMPILE) -C $(UBOOT_PATH) O=$(_uboot_intermediates) $(LINEAGE_BUILD)_defconfig
	$(hide) +$(KERNEL_MAKE_CMD) $(KERNEL_CROSS_COMPILE) -C $(UBOOT_PATH) O=$(_uboot_intermediates) $(notdir $@)

include $(BUILD_SYSTEM)/base_rules.mk
