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

TARGET_TEGRA_DEFAULT_BRANCH ?= rel-shield-r
TARGET_TEGRA_L4T_BRANCH     ?= r35

TARGET_TEGRA_AUDIO    ?= $(TARGET_TEGRA_DEFAULT_BRANCH)
TARGET_TEGRA_CEC      ?= $(TARGET_TEGRA_DEFAULT_BRANCH)
TARGET_TEGRA_GPU      ?= $(TARGET_TEGRA_DEFAULT_BRANCH)
TARGET_TEGRA_KEYSTORE ?= $(TARGET_TEGRA_DEFAULT_BRANCH)
TARGET_TEGRA_MEMTRACK ?= $(TARGET_TEGRA_DEFAULT_BRANCH)
TARGET_TEGRA_OMX      ?= $(TARGET_TEGRA_DEFAULT_BRANCH)
TARGET_TEGRA_PHS      ?= $(TARGET_TEGRA_DEFAULT_BRANCH)

TARGET_TEGRA_HEALTH ?= common
TARGET_TEGRA_POWER  ?= aosp

# Enable nvidia framework enhancements if available
-include vendor/lineage/product/nvidia.mk

# Properties
include device/nvidia/tegra-common/properties.mk

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

DEVICE_PACKAGE_OVERLAYS += \
    device/nvidia/tegra-common/overlay

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += device/nvidia/tegra-common

# Ramdisk
PRODUCT_PACKAGES += \
    bt_loader \
    wifi_loader \
    init.comms.rc \
    init.hdcp.rc \
    init.none.rc \
    init.nv_dev_board.usb.rc \
    init.recovery.usb.rc \
    init.sata.configs.rc \
    init.tegra.rc \
    init.tegra_emmc.rc \
    init.tegra_sata.rc \
    init.tegra_sd.rc \
    init.xusb.configfs.usb.rc

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml

# Audio
ifneq ($(TARGET_TEGRA_AUDIO),)
PRODUCT_PACKAGES += \
    android.hardware.audio.service \
    android.hardware.audio@6.0 \
    android.hardware.audio@6.0-impl \
    android.hardware.audio.common@6.0 \
    android.hardware.audio.common@6.0-util \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.bluetooth.audio-impl \
    audio.bluetooth.default \
    audio.r_submix.default \
    audio.usb.default

PRODUCT_PACKAGES += \
    primary_module_deviceports.xml \
    primary_module_deviceports_tv.xml \
    primary_module_mixports.xml

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/surround_sound_configuration_5_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/surround_sound_configuration_5_0.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

ifneq ($(filter rel-shield-r, $(TARGET_TEGRA_AUDIO)),)
ifneq ($(filter audio, $(TARGET_TEGRA_DOLBY)),)
PRODUCT_PACKAGES += \
    msd_audio_policy_configuration.xml
endif
else ifeq ($(TARGET_TEGRA_AUDIO),tinyhal)
PRODUCT_PACKAGES += \
    audio.primary.tegra
endif
endif

# Bluetooth
ifneq ($(TARGET_TEGRA_BT),)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

ifneq ($(filter bcm, $(TARGET_TEGRA_BT)),)
PRODUCT_PACKAGES += \
    libbt-vendor \
    android.hardware.bluetooth@1.1-service
endif

ifneq ($(filter btlinux, $(TARGET_TEGRA_BT)),)
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.1-service.btlinux \
    android.hardware.bluetooth@1.1-service.btlinux-tegra.rc
endif
endif

# Boot Control
ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-service \
    android.hardware.boot@1.0-impl.nvidia \
    android.hardware.boot@1.0-impl.nvidia.recovery

PRODUCT_PACKAGES_DEBUG += \
    bootctrl
endif

# GMS
PRODUCT_GMS_CLIENTID_BASE ?= android-nvidia

# Graphics
ifeq ($(TARGET_TEGRA_GPU),drm)
PRODUCT_PACKAGES += \
    hwcomposer.drm \
    gralloc.gbm \
    libGLES_mesa
else ifeq ($(TARGET_TEGRA_GPU),swiftshader)
PRODUCT_PACKAGES += \
    libEGL_swiftshader \
    libGLESv1_CM_swiftshader \
    libGLESv2_swiftshader \
    libyuv
endif

# Health HAL
ifeq ($(TARGET_TEGRA_HEALTH),common)
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-service.tegra
else ifeq ($(TARGET_TEGRA_HEALTH),nobattery)
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-service.tegra_nobatt
endif

# Kernel
ifneq ($(TARGET_PREBUILT_KERNEL),)
ifeq ($(LINEAGE_BUILD),)
PRODUCT_COPY_FILES += \
    $(TARGET_PREBUILT_KERNEL):kernel
endif
endif

# Keystore
ifeq ($(TARGET_TEGRA_KEYSTORE),software)
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.software \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service
endif

# Memtrack
ifeq ($(TARGET_TEGRA_MEMTRACK),lineage)
PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-service-nvidia
endif

# OMX
ifeq ($(TARGET_TEGRA_OMX),software)
PRODUCT_PROPERTY_OVERRIDES += \
    debug.stagefright.c2-poolmask=0x80000 \
    debug.stagefright.ccodec=0
endif

# PHS
ifneq ($(TARGET_TEGRA_PHS),)
PRODUCT_PACKAGES += \
    init.nvphsd_setup.rc \
    nvphsd.rc \
    nvphsd_common.conf \
    nvphsd_setup.sh
endif

# Power
ifneq ($(filter $(TARGET_TEGRA_POWER), aosp lineage),)
TARGET_POWERHAL_VARIANT := tegra
PRODUCT_PACKAGES += \
    vendor.nvidia.hardware.power@1.0-service
endif

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
    device/nvidia/tegra-common/seccomp/mediacodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/nvidia/tegra-common/seccomp/mediaextractor.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

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

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service.basic

# Wifi
ifneq ($(TARGET_TEGRA_WIFI),)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    hostapd \
    wificond \
    libwpa_client \
    wpa_supplicant \
    wpa_supplicant.conf \
    p2p_supplicant_overlay.conf \
    wpa_supplicant_overlay.conf
endif

ifeq ($(TARGET_TEGRA_WIREGUARD),compat)
PRODUCT_PACKAGES += \
    wireguard
endif
