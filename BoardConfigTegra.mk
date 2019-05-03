#
# Copyright (C) 2019 The LineageOS Project
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

# Health
ifneq ($(filter $(TARGET_TEGRA_HEALTH), common nobattery),)
DEVICE_FRAMEWORK_MANIFEST_FILE := system/libhidl/vintfdata/manifest_healthd_exclude.xml
DEVICE_MANIFEST_FILE += device/nvidia/tegra-common/manifests/health.xml
endif

# Sepolicy
BOARD_SEPOLICY_DIRS += \
    device/nvidia/tegra-common/sepolicy/upstream \
    device/nvidia/tegra-common/sepolicy/lineage

# TWRP Support
ifeq ($(WITH_TWRP),true)
include device/nvidia/tegra-common/twrp.mk
endif

# Usb
DEVICE_MANIFEST_FILE += device/nvidia/tegra-common/manifests/usb.xml
