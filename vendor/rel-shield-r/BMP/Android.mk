# Copyright (C) 2024 The LineageOS Project
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

LOCAL_PATH := $(call my-dir)
COMMON_BMP_PATH := $(BUILD_TOP)/vendor/nvidia/common/rel-shield-r/BMP

BUP_PATH := $(BUILD_TOP)/vendor/nvidia/common/r35/tegraflash

include $(CLEAR_VARS)
LOCAL_MODULE       := bmp.blob
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH  := $(PRODUCT_OUT)

_bmp_blob_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))
_bmp_blob := $(_bmp_blob_intermediates)/$(LOCAL_MODULE)$(LOCAL_MODULE_SUFFIX)

$(_bmp_blob):
	OUT=$(dir $@) TOP=$(BUILD_TOP) python2 $(BUP_PATH)/BUP_generator.py -t bmp -e \
		"$(COMMON_BMP_PATH)/nvidia480.bmp nvidia 480; \
		 $(COMMON_BMP_PATH)/nvidia720.bmp nvidia 720; \
		 $(COMMON_BMP_PATH)/nvidia810.bmp nvidia 810; \
		 $(COMMON_BMP_PATH)/nvidia1080.bmp nvidia 1080; \
		 $(COMMON_BMP_PATH)/nvidia4k.bmp nvidia 4k; \
		 $(COMMON_BMP_PATH)/verity_orange_continue_720.bmp verity_orange_continue 720; \
		 $(COMMON_BMP_PATH)/verity_orange_continue_1080.bmp verity_orange_continue 1080; \
		 $(COMMON_BMP_PATH)/verity_orange_pause_720.bmp verity_orange_pause 720; \
		 $(COMMON_BMP_PATH)/verity_orange_pause_1080.bmp verity_orange_pause 1080; \
		 $(COMMON_BMP_PATH)/verity_red_continue_720.bmp verity_red_continue 720; \
		 $(COMMON_BMP_PATH)/verity_red_continue_1080.bmp verity_red_continue 1080; \
		 $(COMMON_BMP_PATH)/verity_red_pause_720.bmp verity_red_pause 720; \
		 $(COMMON_BMP_PATH)/verity_red_pause_1080.bmp verity_red_pause 1080; \
		 $(COMMON_BMP_PATH)/verity_red_stop_720.bmp verity_red_stop 720; \
		 $(COMMON_BMP_PATH)/verity_red_stop_1080.bmp verity_red_stop 1080; \
		 $(COMMON_BMP_PATH)/verity_yellow_continue_720.bmp verity_yellow_continue 720; \
		 $(COMMON_BMP_PATH)/verity_yellow_continue_1080.bmp verity_yellow_continue 1080; \
		 $(COMMON_BMP_PATH)/verity_yellow_pause_720.bmp verity_yellow_pause 720; \
		 $(COMMON_BMP_PATH)/verity_yellow_pause_1080.bmp verity_yellow_pause 1080"

include $(BUILD_SYSTEM)/base_rules.mk
