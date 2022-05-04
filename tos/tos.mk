# Copyright (C) 2022 The LineageOS Project
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

TOS_SCRIPT_PATH := $(call my-dir)

ATF_BIN        := $(PRODUCT_OUT)/bl31.bin
ATF_TRUSTY_BIN := $(PRODUCT_OUT)/bl31-trusty.bin
TRUSTY_BIN     := $(PRODUCT_OUT)/trusty.bin

include $(CLEAR_VARS)

LOCAL_MODULE        := tos-mon-only
LOCAL_MODULE_SUFFIX := .img
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_MODULE_PATH   := $(PRODUCT_OUT)

_tos_mon_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))
_tos_mon_bin := $(_tos_mon_intermediates)/$(LOCAL_MODULE)$(LOCAL_MODULE_SUFFIX)

$(_tos_mon_bin): $(ATF_BIN)
	@mkdir -p $(dir $@)
	@python2 $(TOS_SCRIPT_PATH)/gen_tos_part_img.py --monitor=$(ATF_BIN) $@

include $(BUILD_SYSTEM)/base_rules.mk

include $(CLEAR_VARS)

LOCAL_MODULE        := tos-trusty
LOCAL_MODULE_SUFFIX := .img
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_MODULE_PATH   := $(PRODUCT_OUT)

_tos_trusty_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))
_tos_trusty_bin := $(_tos_trusty_intermediates)/$(LOCAL_MODULE)$(LOCAL_MODULE_SUFFIX)

$(_tos_trusty_bin): $(ATF_TRUSTY_BIN) $(TRUSTY_BIN)
	@mkdir -p $(dir $@)
	@python2 $(TOS_SCRIPT_PATH)/gen_tos_part_img.py --monitor=$(ATF_TRUSTY_BIN) --os=$(TRUSTY_BIN) --tostype=trusty $@

include $(BUILD_SYSTEM)/base_rules.mk
