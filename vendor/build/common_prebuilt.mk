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

ifneq ("$(LOCAL_SRC_FILES)","")
NVIDIA_SRC_FILES_32 := $(shell (echo $(LOCAL_SRC_FILES) |cut -d/ -f12-))
NVIDIA_SRC_FILES_64 := $(shell (echo $(LOCAL_SRC_FILES) |cut -d/ -f12-))
endif
ifneq ("$(LOCAL_SRC_FILES_32)","")
NVIDIA_SRC_FILES_32 := $(shell (echo $(LOCAL_SRC_FILES_32) |cut -d/ -f12-))
endif
ifneq ("$(LOCAL_SRC_FILES_64)","")
NVIDIA_SRC_FILES_64 := $(shell (echo $(LOCAL_SRC_FILES_64) |cut -d/ -f12-))
endif

ifeq ("$(wildcard vendor/nvidia/$(TARGET_TEGRA_VERSION)/$(shell (echo $(LOCAL_PATH) |awk -F/ '{ print $$(NF-1) "/" $$(NF) }'))/$(NVIDIA_SRC_FILES_32))","")
ifeq ("$(wildcard vendor/nvidia/$(TARGET_TEGRA_VERSION)/$(shell (echo $(LOCAL_PATH) |awk -F/ '{ print $$(NF-1) "/" $$(NF) }'))/$(NVIDIA_SRC_FILES_64))","")
ifeq ("$(wildcard vendor/nvidia/$(TARGET_DEVICE)/$(shell (echo $(LOCAL_PATH) |awk -F/ '{ print $$(NF-1) "/" $$(NF) }'))/$(NVIDIA_SRC_FILES_32))","")
ifeq ("$(wildcard vendor/nvidia/$(TARGET_DEVICE)/$(shell (echo $(LOCAL_PATH) |awk -F/ '{ print $$(NF-1) "/" $$(NF) }'))/$(NVIDIA_SRC_FILES_64))","")
include $(BUILD_NVIDIA_PREBUILT)
endif
endif
endif
endif
