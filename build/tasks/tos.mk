# Copyright (C) 2022-2024 The LineageOS Project
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
TOS_SCRIPT_PATH := $(call my-dir)

# 1: Target base filename
# 2: Target bl31 base filename
# 3: Optional tee dependency
# 4: Optional tee paramaters
define tos_rule
$(PRODUCT_OUT)/$(1).img: $(PRODUCT_OUT)/$(2).bin $(3)
	@python2 $(TOS_SCRIPT_PATH)/gen_tos_part_img.py --monitor=$(PRODUCT_OUT)/$(2).bin $(4) $(PRODUCT_OUT)/$(1).img

.PHONY: $(1)
$(1): $(PRODUCT_OUT)/$(1).img
endef

$(eval $(call tos_rule,tos-mon-only,bl31))
$(eval $(call tos_rule,tos-trusty,bl31-trusty,$(PRODUCT_OUT)/trusty.bin,--tostype=trusty --os=$(PRODUCT_OUT)/trusty.bin))
endif
