# Copyright (C) 2020-2024 The LineageOS Project
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

ifneq ($(TARGET_TEGRA_UBOOT_CONFIG),)
TARGET_TEGRA_UBOOT_PATH ?= external/u-boot

BUILD_TOOLS_BINS         := $(BUILD_TOP)/prebuilts/build-tools/$(HOST_PREBUILT_TAG)/bin
TARGET_KERNEL_CLANG_PATH ?= $(BUILD_TOP)/prebuilts/clang/host/$(HOST_PREBUILT_TAG)/$(LLVM_PREBUILTS_VERSION)

_uboot_bin := $(call intermediates-dir-for,EXECUTABLES,u-boot-dtb)/u-boot-dtb.bin
$(_uboot_bin):
	@mkdir -p $(dir $@)
	$(hide) +$(KERNEL_MAKE_CMD) $(KERNEL_CROSS_COMPILE) \
		HOSTCC=$(TARGET_KERNEL_CLANG_PATH)/bin/clang HOSTLDFLAGS="-fuse-ld=lld" \
		YACC=$(BUILD_TOOLS_BINS)/bison LEX=$(BUILD_TOOLS_BINS)/flex M4=$(BUILD_TOOLS_BINS)/m4 \
		-C $(TARGET_TEGRA_UBOOT_PATH) O=$(dir $(_uboot_bin)) $(TARGET_TEGRA_UBOOT_CONFIG)_defconfig
	$(hide) +$(KERNEL_MAKE_CMD) $(KERNEL_CROSS_COMPILE) \
		HOSTCC=$(TARGET_KERNEL_CLANG_PATH)/bin/clang HOSTLDFLAGS="-fuse-ld=lld" \
		YACC=$(BUILD_TOOLS_BINS)/bison LEX=$(BUILD_TOOLS_BINS)/flex M4=$(BUILD_TOOLS_BINS)/m4 \
		-C $(TARGET_TEGRA_UBOOT_PATH) O=$(dir $(_uboot_bin)) $(notdir $@)

$(PRODUCT_OUT)/u-boot-dtb.bin: $(_uboot_bin)
	$(hide) cp $< $@

.PHONY: u-boot-dtb
u-boot-dtb: $(PRODUCT_OUT)/u-boot-dtb.bin
endif
