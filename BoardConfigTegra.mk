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
USE_XML_AUDIO_POLICY_CONF := 1
TARGET_EXCLUDES_AUDIOFX := true

# Bluetooth
ifneq ($(TARGET_TEGRA_BT),)
BOARD_HAVE_BLUETOOTH := true
DEVICE_MANIFEST_FILE += device/nvidia/tegra-common/manifests/bluetooth.xml

ifeq ($(TARGET_TEGRA_BT),bcm)
BOARD_HAVE_BLUETOOTH_BCM := true
endif
endif

# Boot Control
ifeq ($(AB_OTA_UPDATER),true)
DEVICE_MANIFEST_FILE += device/nvidia/tegra-common/manifests/boot.xml
endif

# Forced shims
ifeq ($(TARGET_TEGRA_AUDIO),nvaudio)
TARGET_LD_SHIM_LIBS += /$(TARGET_COPY_OUT_VENDOR)/lib/hw/audio.primary.tegra.so|/system/lib/libprocessgroup.so \
                       /$(TARGET_COPY_OUT_VENDOR)/lib/hw/sound_trigger.primary.tegra.so|/system/lib/libprocessgroup.so
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

# Memtrack
ifeq ($(TARGET_TEGRA_MEMTRACK),lineage)
include hardware/nvidia/memtrack/BoardMemtrack.mk
endif

# Odm permissions
TARGET_FS_CONFIG_GEN += device/nvidia/tegra-common/config.fs

# Omx
ifeq ($(TARGET_TEGRA_OMX),software)
DEVICE_MANIFEST_FILE += device/nvidia/tegra-common/manifests/omx.xml
endif

# Power
ifneq ($(filter $(TARGET_TEGRA_POWER), aosp lineage),)
include hardware/nvidia/power/BoardPower.mk
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

# Wifi
ifneq ($(TARGET_TEGRA_WIFI),)
ifeq ($(TARGET_TEGRA_WIFI),bcm)
BOARD_WLAN_DEVICE                := bcmdhd
WIFI_DRIVER_FW_PATH_STA          := "/vendor/firmware/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_AP           := "/vendor/firmware/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_P2P          := "/vendor/firmware/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_PARAM        := "/data/vendor/wifi/fw_path"
WIFI_DRIVER_MODULE_ARG           := "iface_name=wlan0"
WIFI_DRIVER_MODULE_NAME          := "bcmdhd"
else ifeq ($(TARGET_TEGRA_WIFI),rtl8822ce)
# This driver works with bcm userspace
BOARD_WLAN_DEVICE                := bcmdhd
WIFI_DRIVER_MODULE_NAME          := "rtl8822ce"
endif

BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
DEVICE_MANIFEST_FILE             += device/nvidia/tegra-common/manifests/wifi.xml
endif
