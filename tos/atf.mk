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

ATF_PATH ?= external/arm-trusted-firmware
ATF_CROSS_COMPILE ?= CROSS_COMPILE="$(CCACHE_BIN) $(KERNEL_TOOLCHAIN)/$(KERNEL_TOOLCHAIN_PREFIX)"

include $(CLEAR_VARS)

LOCAL_MODULE        := bl31
LOCAL_MODULE_SUFFIX := .bin
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_MODULE_PATH   := $(PRODUCT_OUT)

_atf_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))
_atf_bin := $(_atf_intermediates)/$(LOCAL_MODULE)$(LOCAL_MODULE_SUFFIX)

$(_atf_bin):
	@mkdir -p $(dir $@)
	$(hide) +$(KERNEL_MAKE_CMD) $(ATF_CROSS_COMPILE) -C $(ATF_PATH) $(ATF_PARAMS) BUILD_BASE=$(abspath $(_atf_intermediates)) PLAT=tegra TARGET_SOC=$(TARGET_TEGRA_VERSION) bl31
	@cp $(dir $@)/tegra/$(TARGET_TEGRA_VERSION)/release/bl31.bin $@

include $(BUILD_SYSTEM)/base_rules.mk
