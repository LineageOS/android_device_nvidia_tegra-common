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

include $(CLEAR_VARS)

LOCAL_MODULE               := p2p_supplicant.conf
LOCAL_MODULE_RELATIVE_PATH := wifi
LOCAL_MODULE_CLASS         := ETC
LOCAL_VENDOR_MODULE        := true

_p2p_supplicant_conf_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))
_p2p_supplicant_conf := $(_p2p_supplicant_conf_intermediates)/$(LOCAL_MODULE)
_wpa_supplicant_conf_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),wpa_supplicant.conf)
_wpa_supplicant_conf := $(_wpa_supplicant_conf_intermediates)/wpa_supplicant.conf

$(_p2p_supplicant_conf): $(_wpa_supplicant_conf)
	@mkdir -p $(dir $@)
	@cp $(_wpa_supplicant_conf) $@
	@cp  $@ $(TARGET_OUT_VENDOR_ETC)/$(LOCAL_MODULE_RELATIVE_PATH)/

include $(BUILD_SYSTEM)/base_rules.mk
