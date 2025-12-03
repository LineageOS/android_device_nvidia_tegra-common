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

# Baseline Manifest, must be declared before any module manifests
DEVICE_MANIFEST_FILE ?= device/nvidia/tegra-common/manifests/manifest.$(TARGET_TEGRA_MAN_LVL).xml

# Graphics
ifeq ($(TARGET_GRAPHICS),mesa)
BOARD_MESA3D_GALLIUM_DRIVERS += nouveau tegra
endif

# Wifi
BOARD_WLAN_DEVICE                := bcmdhd
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)

include device/nvidia/sepolicy/sepolicy.mk
include device/mainline/common/BoardConfigMainlineCommon.mk
