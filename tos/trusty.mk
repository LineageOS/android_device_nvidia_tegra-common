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

include $(CLEAR_VARS)

LOCAL_MODULE        := trusty
LOCAL_MODULE_SUFFIX := .bin
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_MODULE_PATH   := $(PRODUCT_OUT)

_trusty_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))
_trusty_bin := $(_trusty_intermediates)/$(LOCAL_MODULE)$(LOCAL_MODULE_SUFFIX)

TARGET_KERNEL_CLANG_PATH ?= $(BUILD_TOP)/prebuilts/clang/host/$(HOST_PREBUILT_TAG)/$(LLVM_PREBUILTS_VERSION)
CLANG_TOOLS_PATH ?= $(BUILD_TOP)/prebuilts/clang-tools/$(HOST_PREBUILT_TAG)
TARGET_KERNEL_RUST_VERSION ?= 1.73.0c
RUST_PATH ?= $(BUILD_TOP)/prebuilts/rust/$(HOST_PREBUILT_TAG)/$(TARGET_KERNEL_RUST_VERSION)
BUILD_TOOLS_PATH ?= $(BUILD_TOP)/prebuilts/build-tools/$(HOST_PREBUILT_TAG)
NPROC := $(shell prebuilts/tools-lineage/$(HOST_PREBUILT_TAG)/bin/nproc --all)
LKROOT ?= $(BUILD_TOP)/external/trusty/lk
include $(BUILD_TOP)/trusty/vendor/google/aosp/lk_inc_aosp.mk
LKINC += trusty/hardware/nvidia

$(_trusty_bin):
	@mkdir -p $(dir $@)
	$(KERNEL_MAKE_CMD) -j $(NPROC) -f $(LKROOT)/makefile PROJECT=$(TARGET_TEGRA_VERSION) \
		LKROOT=$(LKROOT) LKINC="$(LKINC)" BUILDROOT=$(dir $@) TRUSTY_TOP=$(BUILD_TOP) BUILDTOOLS_BINDIR=$(BUILD_TOOLS_PATH)/bin \
		CLANG_BINDIR=$(TARGET_KERNEL_CLANG_PATH)/bin CLANG_TOOLS_BINDIR=$(CLANG_TOOLS_PATH)/bin CLANG_HOST_LIBDIR=$(TARGET_KERNEL_CLANG_PATH)/lib \
		BINDGEN_CLANG_PATH=$(TARGET_KERNEL_CLANG_PATH)/bin/clang BINDGEN_LIBCLANG_PATH=$(TARGET_KERNEL_CLANG_PATH)/lib \
		RUST_BINDIR=$(RUST_PATH)/bin RUST_HOST_LIBDIR=$(RUST_PATH)/lib/rustlib/x86_64-unknown-linux-gnu/lib \
		ARCH_arm_TOOLCHAIN_PREFIX=$(TARGET_KERNEL_CLANG_PATH)/bin/llvm- \
		ARCH_arm64_TOOLCHAIN_PREFIX=$(TARGET_KERNEL_CLANG_PATH)/bin/llvm-
	@cp $(dir $@)/build-$(TARGET_TEGRA_VERSION)/lk.bin $@

include $(BUILD_SYSTEM)/base_rules.mk
