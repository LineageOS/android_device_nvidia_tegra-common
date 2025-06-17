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

ifneq ($(filter t186 t194, $(TARGET_TEGRA_VERSION)),)
CBOOT_PATH ?= bootable/cboot/lk

# 1: Intermediates dir
# 2: Target base filename
# 3: Optional build paramters
define cboot_rule
$(1)/$(2).bin:
	@mkdir -p $(1)
	$(hide) +$(KERNEL_MAKE_CMD) -C $(CBOOT_PATH) BUILDROOT=$(abspath $(1)) PROJECT=$(TARGET_TEGRA_VERSION) TOP=$(BUILD_TOP) TOOLCHAIN_PREFIX=$(KERNEL_TOOLCHAIN)/$(KERNEL_TOOLCHAIN_PREFIX) NOECHO=$(hide) DEBUG=2 PLATFORM_IS_AFTER_N=1 $(3)
	@cp $(1)/build-$(TARGET_TEGRA_VERSION)/lk.bin $(1)/$(2).bin

$(PRODUCT_OUT)/$(2).bin: $(1)/$(2).bin
	$(hide) cp $(1)/$(2).bin $(PRODUCT_OUT)/$(2).bin

.PHONY: $(2)
$(2): $(PRODUCT_OUT)/$(2).bin
endef

$(eval $(call cboot_rule,$(call intermediates-dir-for,EXECUTABLES,cboot),cboot))
$(eval $(call cboot_rule,$(call intermediates-dir-for,EXECUTABLES,nvdisp-init),nvdisp-init,NVDISP_INIT_ONLY=true))
endif
