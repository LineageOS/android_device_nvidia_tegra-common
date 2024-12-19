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

COMMON_REALTEK_PATH := vendor/nvidia/common/r35/realtek

# Rtl8822ce firmware
PRODUCT_COPY_FILES += \
    $(COMMON_REALTEK_PATH)/rtl8822cu/rtl8822cu_config:$(TARGET_COPY_OUT_VENDOR)/firmware/rtl8822cu_config \
    $(COMMON_REALTEK_PATH)/rtl8822cu/rtl8822cu_fw:$(TARGET_COPY_OUT_VENDOR)/firmware/rtl8822cu_fw \
    $(COMMON_REALTEK_PATH)/rtl8822cu/rtl8822_setting.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/rtl8822_setting.bin
