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

# Audio
TARGET_EXCLUDES_AUDIOFX := true

# Bluetooth
ifneq ($(TARGET_TEGRA_BT),)
BOARD_HAVE_BLUETOOTH := true
DEVICE_MANIFEST_FILE += device/nvidia/tegra-common/manifests/bluetooth.xml

ifneq ($(filter bcm, $(TARGET_TEGRA_BT)),)
BOARD_HAVE_BLUETOOTH_BCM := true
endif
endif

# Boot Control
ifeq ($(AB_OTA_UPDATER),true)
DEVICE_MANIFEST_FILE += device/nvidia/tegra-common/manifests/boot.xml
endif

# Graphics
ifeq ($(TARGET_TEGRA_GPU),drm)
BOARD_GPU_DRIVERS         ?= nouveau
BOARD_USES_DRM_HWCOMPOSER := true
DEVICE_MANIFEST_FILE      += device/nvidia/tegra-common/manifests/drm.xml
TARGET_USES_HWC2          := true
else ifeq ($(TARGET_TEGRA_GPU),swiftshader)
TARGET_USES_HWC2          := true
endif

# Malloc
MALLOC_SVELTE := true

# Odm permissions
TARGET_FS_CONFIG_GEN += device/nvidia/tegra-common/config.fs

# TWRP Support
ifeq ($(WITH_TWRP),true)
include device/nvidia/tegra-common/twrp.mk
endif

# Wifi
ifneq ($(TARGET_TEGRA_WIFI),)
# rtl8822ce driver works with bcm userspace
ifneq ($(filter $(TARGET_TEGRA_WIFI), bcm rtl8822ce),)
BOARD_WLAN_DEVICE                := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM        := "/data/vendor/wifi/fw_path"
endif

BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
endif

include device/nvidia/sepolicy/sepolicy.mk
