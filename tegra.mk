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
TARGET_TEGRA_GPU      ?= $(TARGET_TEGRA_DEFAULT_BRANCH)
TARGET_TEGRA_OMX      ?= $(TARGET_TEGRA_DEFAULT_BRANCH)
TARGET_TEGRA_PHS      ?= $(TARGET_TEGRA_DEFAULT_BRANCH)
TARGET_TEGRA_TOS      ?= $(if $(TARGET_TEGRA_KEYSTORE),$(TARGET_TEGRA_KEYSTORE),$(TARGET_TEGRA_DEFAULT_BRANCH))

TARGET_TEGRA_CEC      ?= lineage
TARGET_TEGRA_HEALTH   ?= aosp
TARGET_TEGRA_MEMTRACK ?= lineage
TARGET_TEGRA_POWER    ?= aosp

ifeq ($(TARGET_TEGRA_MAN_LVL),)
ifeq ($(TARGET_TEGRA_KERNEL),4.9)
TARGET_TEGRA_MAN_LVL := 5
else ifeq ($(TARGET_TEGRA_KERNEL),5.10)
TARGET_TEGRA_MAN_LVL := 6
else ifeq ($(TARGET_TEGRA_KERNEL),5.15)
TARGET_TEGRA_MAN_LVL := 7
else ifeq ($(TARGET_TEGRA_KERNEL),6.1)
TARGET_TEGRA_MAN_LVL := 8
else ifeq ($(TARGET_TEGRA_KERNEL),6.6)
TARGET_TEGRA_MAN_LVL := 202404
endif
endif

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
TARGET_EXCLUDES_AUDIOFX := true
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
    msd_audio_policy_configuration.xml \
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

ifeq ($(TARGET_TEGRA_AUDIO),tinyhal)
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
ifneq ($(TARGET_TEGRA_BOOTCTRL),)
AB_OTA_UPDATER := true
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-service
PRODUCT_PACKAGES_DEBUG += \
    bootctrl

ifeq ($(TARGET_TEGRA_BOOTCTRL),smd)
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-impl.nvidia \
    android.hardware.boot@1.0-impl.nvidia.recovery
else ifeq ($(TARGET_TEGRA_BOOTCTRL),efi)
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-impl.nvidia-efi \
    android.hardware.boot@1.0-impl.nvidia-efi.recovery
endif
endif

# CEC
ifneq ($(TARGET_TEGRA_CEC),)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.hdmi.cec.xml

ifeq ($(TARGET_TEGRA_CEC),lineage)
PRODUCT_PACKAGES += \
    android.hardware.tv.cec@1.0-service.nvidia
else ifeq ($(TARGET_TEGRA_CEC),aosp)
PRODUCT_PACKAGES += \
    android.hardware.tv.cec@1.0-service \
    android.hardware.tv.cec@1.0-impl
else
PRODUCT_PACKAGES += \
    android.hardware.tv.cec@1.0-service \
    android.hardware.tv.cec@1.0-impl.nvidia
endif
endif

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey

# fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# GMS
PRODUCT_GMS_CLIENTID_BASE ?= android-nvidia

# Graphics
ifneq ($(TARGET_TEGRA_GPU),)
PRODUCT_PACKAGES += \
    disable_configstore
endif
ifeq ($(TARGET_TEGRA_GPU),drm)
PRODUCT_SOONG_NAMESPACES += external/mesa3d
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@4.0-service.minigbm \
    android.hardware.graphics.mapper@4.0-impl.minigbm \
    android.hardware.graphics.composer@2.4-service \
    hwcomposer.drm \
    gralloc.minigbm \
    libGLES_mesa
else ifeq ($(TARGET_TEGRA_GPU),swiftshader)
PRODUCT_REQUIRES_INSECURE_EXECMEM_FOR_SWIFTSHADER := true
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@4.0-service.minigbm \
    android.hardware.graphics.mapper@4.0-impl.minigbm \
    android.hardware.graphics.composer@2.4-service \
    hwcomposer.drm_minigbm \
    gralloc.minigbm \
    vulkan.pastel
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2020-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml
endif

# Health HAL
ifeq ($(TARGET_TEGRA_HEALTH),aosp)
PRODUCT_PACKAGES += \
    android.hardware.health-service.example \
    android.hardware.health-service.example_recovery
else ifeq ($(TARGET_TEGRA_HEALTH),nobattery)
PRODUCT_PACKAGES += \
    android.hardware.health-service.tegra_nobatt \
    android.hardware.health-service.tegra_nobatt_recovery
endif

# Kernel
ifneq ($(TARGET_PREBUILT_KERNEL),)
ifeq ($(LINEAGE_BUILD),)
PRODUCT_COPY_FILES += \
    $(TARGET_PREBUILT_KERNEL):kernel
endif
endif

# Light
ifeq ($(TARGET_TEGRA_LIGHT),lineage)
ifeq ($(shell expr $(TARGET_TEGRA_MAN_LVL) \>= 5), 1)
PRODUCT_PACKAGES += \
    android.hardware.light-service-nvidia
else
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service-nvidia
endif
endif

# Memtrack
ifeq ($(TARGET_TEGRA_MEMTRACK),lineage)
ifeq ($(shell expr $(TARGET_TEGRA_MAN_LVL) \>= 6), 1)
PRODUCT_PACKAGES += \
    android.hardware.memtrack-service-nvidia
else
PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-service-nvidia
endif
endif

# OMX
ifeq ($(TARGET_TEGRA_OMX),software)
PRODUCT_PROPERTY_OVERRIDES += \
    debug.stagefright.c2-poolmask=0x80000
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
    device/nvidia/tegra-common/seccomp/mediaswcodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaswcodec.policy \
    device/nvidia/tegra-common/seccomp/mediaextractor.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

# Thermal
ifeq ($(TARGET_TEGRA_THERMAL),lineage)
ifeq ($(shell expr $(TARGET_TEGRA_MAN_LVL) \>= 8), 1)
PRODUCT_PACKAGES += \
    android.hardware.thermal-service-nvidia
else
PRODUCT_PACKAGES += \
    android.hardware.thermal@1.0-service-nvidia
endif
endif

# TOS
ifeq ($(TARGET_TEGRA_TOS),software)
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.software \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service
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

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.3-service.basic

# Wifi
ifneq ($(TARGET_TEGRA_WIFI),)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
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
