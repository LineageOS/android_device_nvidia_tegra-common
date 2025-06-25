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

ifneq ($(TARGET_TEGRA_VERSION),)
ATF_PATH ?= external/arm-trusted-firmware
ATF_CROSS_COMPILE ?= CROSS_COMPILE="$(CCACHE_BIN) $(KERNEL_TOOLCHAIN)/$(KERNEL_TOOLCHAIN_PREFIX)"

# 1: Intermediates dir
# 2: Target base filename
# 3: Optional build paramters
define atf_rule
$(1)/$(2).bin:
	@mkdir -p $(1)
	$(hide) +$(KERNEL_MAKE_CMD) $(ATF_CROSS_COMPILE) -C $(ATF_PATH) $(ATF_PARAMS) BUILD_BASE=$(abspath $(1)) PLAT=tegra TARGET_SOC=$(TARGET_TEGRA_VERSION) $(3) bl31
	@cp $(1)/tegra/$(TARGET_TEGRA_VERSION)/release/bl31.bin $(1)/$(2).bin

$(PRODUCT_OUT)/$(2).bin: $(1)/$(2).bin
	$(hide) cp $(1)/$(2).bin $(PRODUCT_OUT)/$(2).bin

.PHONY: $(2)
$(2): $(PRODUCT_OUT)/$(2).bin
endef

$(eval $(call atf_rule,$(call intermediates-dir-for,EXECUTABLES,bl31),bl31))
$(eval $(call atf_rule,$(call intermediates-dir-for,EXECUTABLES,bl31_trusty),bl31-trusty,SPD=trusty))
endif
