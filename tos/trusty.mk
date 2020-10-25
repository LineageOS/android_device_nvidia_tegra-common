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

NPROC := $(shell prebuilts/tools-lineage/$(HOST_PREBUILT_TAG)/bin/nproc --all)

$(_trusty_bin):
	@mkdir -p $(dir $@)
	$(KERNEL_MAKE_CMD) -j $(NPROC) -f external/lk/makefile $(TARGET_TEGRA_VERSION) BUILDROOT=$(dir $@) TRUSTY_TOP=$(BUILD_TOP) CLANG_BINDIR=$(CLANG_PREBUILTS)/bin ARCH_arm_TOOLCHAIN_PREFIX=$(KERNEL_TOOLCHAIN_arm)/arm-linux-androideabi- ARCH_arm64_TOOLCHAIN_PREFIX=$(KERNEL_TOOLCHAIN_arm64)/$(KERNEL_TOOLCHAIN_PREFIX_arm64)
	@cp $(dir $@)/build-$(TARGET_TEGRA_VERSION)/lk.bin $@

include $(BUILD_SYSTEM)/base_rules.mk
