#
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
#

LOCAL_PATH := $(call my-dir)

WIREGUARD_PATH := $(BUILD_TOP)/kernel/nvidia/wireguard

include $(CLEAR_VARS)

LOCAL_MODULE               := wireguard
LOCAL_MODULE_SUFFIX        := .ko
LOCAL_MODULE_RELATIVE_PATH := modules
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MULTILIB             := 32
LOCAL_VENDOR_MODULE        := true

_wireguard_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))
_wireguard_ko := $(_wireguard_intermediates)/$(LOCAL_MODULE)$(LOCAL_MODULE_SUFFIX)
KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ

$(_wireguard_ko): $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/$(BOARD_KERNEL_IMAGE_NAME)
	@mkdir -p $(dir $@)
	@cp -R $(WIREGUARD_PATH)/src/* $(_wireguard_intermediates)/
	$(hide) +$(KERNEL_MAKE_CMD) $(PATH_OVERRIDE) $(KERNEL_MAKE_FLAGS) -C $(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(KERNEL_CROSS_COMPILE) M=$(BUILD_TOP)/$(_wireguard_intermediates) modules
	$(KERNEL_TOOLCHAIN_PATH)strip --strip-unneeded $@; \
	cp $@ $(KERNEL_MODULES_OUT)/lib/modules; \

include $(BUILD_SYSTEM)/base_rules.mk
