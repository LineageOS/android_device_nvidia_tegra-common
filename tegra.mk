#
# Copyright (C) 2018 The LineageOS Project
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

TARGET_AUDIO_HAL              ?= baylibre
TARGET_GRAPHICS               ?= mesa
TARGET_GRAPHICS_ALLOCATOR_HAL ?= minigbm
TARGET_LIGHT_HAL              ?= none
TARGET_POWER_HAL              ?= perfmgr-lineage
TARGET_TV_HDMI_CEC_HAL        ?= baylibre

MAINLINE_COMMON_DISABLE_COMMON_PRODUCT_DEFS ?= true
TARGET_HAS_VIBRATOR                         ?= false
TARGET_SUPPORTS_USB_ACCESSORY_MODE          ?= false
TARGET_USES_MAINLINE_COMMON_AB_DEFS         ?= false

ifeq ($(TARGET_GRAPHICS),mesa)
TARGET_MINIGBM_PLATFORM ?= nouveau
endif

# GCC Toolchain needed to build bootloaders
ifeq ($(TARGET_SUPPORTS_64_BIT_APPS),true)
KERNEL_TOOLCHAIN        := $(shell pwd)/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-gnu-9.3/bin
KERNEL_TOOLCHAIN_PREFIX := aarch64-buildroot-linux-gnu-
endif

include device/mainline/common/optional/options.mk
include device/mainline/common/mainline_common.mk

ifeq ($(TARGET_TEGRA_MAN_LVL),)
ifeq ($(TARGET_KERNEL_VERSION),5.15)
TARGET_TEGRA_MAN_LVL := 7
else ifeq ($(TARGET_KERNEL_VERSION),6.1)
TARGET_TEGRA_MAN_LVL := 8
else ifeq ($(TARGET_KERNEL_VERSION),6.6)
TARGET_TEGRA_MAN_LVL := 202404
else ifeq ($(TARGET_KERNEL_VERSION),6.12)
TARGET_TEGRA_MAN_LVL := 202504
else ifeq ($(TARGET_KERNEL_VERSION),6.18)
TARGET_TEGRA_MAN_LVL := 202604
else ifeq ($(TARGET_KERNEL_VERSION),mainline)
TARGET_TEGRA_MAN_LVL := 202604
endif
endif

# Properties
include device/nvidia/tegra-common/properties.mk

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

ifeq ($(PRODUCT_IS_ATV),true)
DEVICE_PACKAGE_OVERLAYS += \
    device/nvidia/tegra-common/overlay-tv
else
DEVICE_PACKAGE_OVERLAYS += \
    device/nvidia/tegra-common/overlay
endif

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += device/nvidia/tegra-common

# Soong variables
$(call soong_config_set,TARGET_TEGRA,VERSION,$(TARGET_TEGRA_VERSION))
$(call soong_config_set,TARGET_TEGRA,VARIANT,$(TARGET_TEGRA_VARIANT))

# Ramdisk
PRODUCT_PACKAGES += \
    bt_loader
PRODUCT_COPY_FILES += \
    device/nvidia/tegra-common/initfiles/init.comms.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.comms.rc \
    device/nvidia/tegra-common/initfiles/init.hdcp.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.hdcp.rc \
    device/nvidia/tegra-common/initfiles/init.none.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.none.rc \
    device/nvidia/tegra-common/initfiles/init.nv_dev_board.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nv_dev_board.usb.rc \
    device/nvidia/tegra-common/initfiles/init.sata.configs.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.sata.configs.rc \
    device/nvidia/tegra-common/initfiles/init.tegra.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.tegra.rc \
    device/nvidia/tegra-common/initfiles/init.tegra_emmc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.tegra_emmc.rc \
    device/nvidia/tegra-common/initfiles/init.tegra_sata.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.tegra_sata.rc \
    device/nvidia/tegra-common/initfiles/init.tegra_sd.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.tegra_sd.rc \
    device/nvidia/tegra-common/initfiles/init.xusb.configfs.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.xusb.configfs.usb.rc \
    device/nvidia/tegra-common/initfiles/init.recovery.usb.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.usb.rc

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# Audio
TARGET_EXCLUDES_AUDIOFX := true

# Bluetooth
ifneq ($(TARGET_BLUETOOTH_HAL),)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml
endif

# Boot Control
ifeq ($(TARGET_BOOT_HAL),)
AB_OTA_UPDATER := false
$(call inherit-product, $(SRC_TARGET_DIR)/product/non_ab_device.mk)
else
AB_OTA_UPDATER := true
ifeq ($(TARGET_BOOT_HAL),smd)
PRODUCT_PACKAGES += \
    android.hardware.boot-service.nvidia \
    android.hardware.boot-service.nvidia.recovery
else ifeq ($(TARGET_BOOT_HAL),efi)
PRODUCT_PACKAGES += \
    android.hardware.boot-service.nvidia-efi \
    android.hardware.boot-service.nvidia-efi.recovery
endif
endif

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@latest-service.clearkey

# fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# GMS
PRODUCT_GMS_CLIENTID_BASE ?= android-nvidia

# Graphics
ifneq ($(TARGET_GRAPHICS),)
PRODUCT_PACKAGES += \
    disable_configstore \
    SimpleSettingsNvgpuOverlay \
    TvSettingsNvgpuOverlay

ifeq ($(TARGET_GRAPHICS),mesa)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2025-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml
endif
endif

# Light
ifeq ($(TARGET_LIGHT_HAL),tegra)
PRODUCT_PACKAGES += \
    android.hardware.light-service-nvidia
endif

# Media
PRODUCT_PACKAGES += \
    media_profiles.xml \
    mediaextractor.policy.vendor \
    mediaswcodec.policy.vendor

ifneq ($(TARGET_SENSORS_HAL),)
TARGET_SENSOR_HAL_FEATURES ?= accelerometer gyroscope
PRODUCT_COPY_FILES += \
    $(foreach feature,$(TARGET_SENSOR_HAL_FEATURES),frameworks/native/data/etc/android.hardware.sensor.$(feature).xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.$(feature).xml)
endif

# Thermal
ifeq ($(TARGET_THERMAL_HAL),tegra)
PRODUCT_PACKAGES += \
    android.hardware.thermal-service-nvidia
endif

# TOS
ifneq ($(TARGET_SUPPORTS_HARDWARE_BACKED_SECURITY),)
ifeq ($(TARGET_SECURITY_KEYMINT_HAL),trusty)
$(call inherit-product, system/core/trusty/trusty-base.mk)
$(call inherit-product, system/core/trusty/trusty-storage.mk)
endif
endif

# TV Input
ifeq ($(PRODUCT_IS_ATV),true)
PRODUCT_PACKAGES += \
    android.hardware.tv.input-service.example
endif

# Update Engine
ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_PACKAGES += \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client
endif

# Virtualization (AVF)
ifeq ($(shell expr $(TARGET_TEGRA_MAN_LVL) \>= 202404), 1)
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)
endif

# Wifi
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    android.hardware.wifi.prebuilt.xml \
    wireless-regdb
PRODUCT_COPY_FILES += \
    device/nvidia/tegra-common/comms/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    device/nvidia/tegra-common/comms/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf
