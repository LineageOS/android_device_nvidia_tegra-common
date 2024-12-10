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

# Audio
ifneq ($(TARGET_TEGRA_AUDIO),)
ifeq ($(filter audio, $(TARGET_TEGRA_DOLBY)),)
DEVICE_MANIFEST_FILE += device/nvidia/tegra-common/manifests/audio.xml
endif
endif

# Bluetooth
ifneq ($(TARGET_TEGRA_BT),)
BOARD_HAVE_BLUETOOTH := true

ifneq ($(filter bcm, $(TARGET_TEGRA_BT)),)
BOARD_HAVE_BLUETOOTH_BCM := true
endif
# Don't include on multi-variant builds
ifeq ($(TARGET_TEGRA_BT),bcm)
DEVICE_MANIFEST_FILE += device/nvidia/tegra-common/manifests/bluetooth.xml
endif
endif

# Boot Control
ifneq ($(TARGET_TEGRA_BOOTCTRL),)
ifeq ($(shell expr $(TARGET_TEGRA_MAN_LVL) \< 8), 1)
DEVICE_MANIFEST_FILE += device/nvidia/tegra-common/manifests/boot.xml
endif
endif

# CEC
ifneq ($(filter-out lineage,$(TARGET_TEGRA_CEC)),)
DEVICE_MANIFEST_FILE += device/nvidia/tegra-common/manifests/cec.xml
endif

# Graphics
ifeq ($(TARGET_GRAPHICS),mesa)
BOARD_MESA3D_GALLIUM_DRIVERS += nouveau tegra
BOARD_MESA3D_VULKAN_DRIVERS += nouveau
BOARD_MESA3D_GALLIUM_VA := enabled
BOARD_MESA3D_VIDEO_CODECS := all
endif

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    device/nvidia/tegra-common/manifests/device_framework_matrix.xml

# Keystore
ifneq ($(TARGET_TEGRA_TOS),)
ifneq ($(filter 3.10 4.9 5.10, $(TARGET_KERNEL_VERSION)),)
DEVICE_MANIFEST_FILE += device/nvidia/tegra-common/manifests/keystore.xml
endif
endif

# Odm permissions
TARGET_FS_CONFIG_GEN += device/nvidia/tegra-common/config.fs

# Power
ifeq ($(filter $(TARGET_TEGRA_POWER), perfmgr),)
include device/lineage/sepolicy/libperfmgr/sepolicy.mk
endif

# Sensors
ifneq ($(TARGET_TEGRA_SENSORS),)
DEVICE_MANIFEST_FILE += device/nvidia/tegra-common/manifests/sensors.xml
endif

# Wifi
ifneq ($(TARGET_TEGRA_WIFI),)
ifneq ($(filter $(TARGET_TEGRA_WIFI), bcm),)
BOARD_WLAN_DEVICE                := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM        := "/data/vendor/wifi/fw_path"
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
endif

BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION      := VER_0_8_X
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
endif

include device/nvidia/sepolicy/sepolicy.mk

ifeq ($(filter 3.10 4.9 5.10, $(TARGET_KERNEL_VERSION)),)
include device/mainline/common/BoardConfigMainlineCommon.mk
endif
