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

ifneq ($(filter 3.10 4.9 5.10, $(TARGET_KERNEL_VERSION)),)
TARGET_TEGRA_AUDIO    ?= $(TARGET_TEGRA_DEFAULT_BRANCH)
TARGET_TEGRA_CPL      ?= $(TARGET_TEGRA_DEFAULT_BRANCH)
TARGET_TEGRA_GPU      ?= $(TARGET_TEGRA_DEFAULT_BRANCH)
TARGET_TEGRA_OMX      ?= $(TARGET_TEGRA_DEFAULT_BRANCH)
TARGET_TEGRA_TOS      ?= $(if $(TARGET_TEGRA_KEYSTORE),$(TARGET_TEGRA_KEYSTORE),$(TARGET_TEGRA_DEFAULT_BRANCH))

TARGET_TEGRA_CEC      ?= lineage
TARGET_TEGRA_HEALTH   ?= aosp
TARGET_TEGRA_MEMTRACK ?= lineage
TARGET_TEGRA_POWER    ?= aosp
else
TARGET_TEGRA_BT     ?= mainline
TARGET_TEGRA_HEALTH ?= aosp
TARGET_TEGRA_WIFI   ?= mainline

TARGET_AUDIO_HAL              ?= baylibre
TARGET_GRAPHICS               ?= mesa
TARGET_GRAPHICS_ALLOCATOR_HAL ?= minigbm
TARGET_HEALTH_HAL             ?= none
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

PRODUCT_PACKAGES += \
    mediaextractor.policy.vendor \
    mediaswcodec.policy.vendor

# GCC Toolchain needed to build bootloaders
ifeq ($(TARGET_SUPPORTS_64_BIT_APPS),true)
KERNEL_TOOLCHAIN        := $(shell pwd)/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-gnu-9.3/bin
KERNEL_TOOLCHAIN_PREFIX := aarch64-buildroot-linux-gnu-
endif

include device/mainline/common/optional/options.mk
include device/mainline/common/mainline_common.mk
endif

ifeq ($(TARGET_TEGRA_MAN_LVL),)
ifeq ($(TARGET_KERNEL_VERSION),4.9)
TARGET_TEGRA_MAN_LVL := 5
else ifeq ($(TARGET_KERNEL_VERSION),5.10)
TARGET_TEGRA_MAN_LVL := 6
else ifeq ($(TARGET_KERNEL_VERSION),5.15)
TARGET_TEGRA_MAN_LVL := 7
else ifeq ($(TARGET_KERNEL_VERSION),6.1)
TARGET_TEGRA_MAN_LVL := 8
else ifeq ($(TARGET_KERNEL_VERSION),6.6)
TARGET_TEGRA_MAN_LVL := 202404
else ifeq ($(TARGET_KERNEL_VERSION),6.12)
TARGET_TEGRA_MAN_LVL := 202504
else ifeq ($(TARGET_KERNEL_VERSION),6.18)
TARGET_TEGRA_MAN_LVL := 202604
endif
endif

ifeq ($(filter $(TARGET_POWER_HAL), perfmgr-lineage),)
ifeq ($(filter $(TARGET_TEGRA_POWER), perfmgr),)
TARGET_TEGRA_PHS ?= $(TARGET_TEGRA_DEFAULT_BRANCH)
endif
endif

# Enable nvidia framework enhancements if available
-include vendor/lineage/product/nvidia.mk

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
    bt_loader \
    wifi_loader
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
ifneq ($(filter audio, $(TARGET_TEGRA_DOLBY)),)
PRODUCT_COPY_FILES += \
    device/nvidia/tegra-common/nvaudio/msd_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/msd_audio_policy_configuration.xml
else
PRODUCT_COPY_FILES += \
    device/nvidia/tegra-common/nvaudio/msd_audio_policy_configuration_dummy.xml:$(TARGET_COPY_OUT_VENDOR)/etc/msd_audio_policy_configuration.xml
endif

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/surround_sound_configuration_5_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/surround_sound_configuration_5_0.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

ifeq ($(TARGET_TEGRA_AUDIO),tinyhal)
PRODUCT_SOONG_NAMESPACES += external/tinyhal
PRODUCT_PACKAGES += \
    audio.primary.tinyhal
endif
endif

# Bluetooth
ifneq ($(TARGET_TEGRA_BT),)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

ifneq ($(filter bcm, $(TARGET_TEGRA_BT)),)
PRODUCT_SOONG_NAMESPACES += hardware/broadcom/libbt
PRODUCT_PACKAGES += \
    libbt-vendor \
    android.hardware.bluetooth@1.1-service
ifeq ($(TARGET_SUPPORTS_64_BIT_APPS),true)
PRODUCT_PACKAGES += bt_impl_symlink64
else
PRODUCT_PACKAGES += bt_impl_symlink
endif
endif

ifneq ($(filter btlinux, $(TARGET_TEGRA_BT)),)
ifeq ($(TARGET_TEGRA_BT),btlinux)
PRODUCT_PACKAGES += \
    android.hardware.bluetooth-service.default
else
PRODUCT_PACKAGES += \
    android.hardware.bluetooth-service.tegra
endif
endif
endif

# Boot Control
ifeq ($(TARGET_TEGRA_BOOTCTRL),)
AB_OTA_UPDATER := false
$(call inherit-product, $(SRC_TARGET_DIR)/product/non_ab_device.mk)
else
AB_OTA_UPDATER := true
ifeq ($(shell expr $(TARGET_TEGRA_MAN_LVL) \>= 8), 1)
ifeq ($(TARGET_TEGRA_BOOTCTRL),smd)
PRODUCT_PACKAGES += \
    android.hardware.boot-service.nvidia \
    android.hardware.boot-service.nvidia.recovery
else ifeq ($(TARGET_TEGRA_BOOTCTRL),efi)
PRODUCT_PACKAGES += \
    android.hardware.boot-service.nvidia-efi \
    android.hardware.boot-service.nvidia-efi.recovery
endif
else
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
    android.hardware.drm@latest-service.clearkey

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
ifneq ($(TARGET_GRAPHICS),)
TARGET_USES_VULKAN ?= false

PRODUCT_PACKAGES += \
    disable_configstore \
    SimpleSettingsNvgpuOverlay \
    TvSettingsNvgpuOverlay
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
ifneq ($(filter 3.10 4.9 5.10, $(TARGET_KERNEL_VERSION)),)
ifneq ($(TARGET_PREBUILT_KERNEL),)
ifeq ($(LINEAGE_BUILD),)
PRODUCT_COPY_FILES += \
    $(TARGET_PREBUILT_KERNEL):kernel
endif
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
PRODUCT_PACKAGES += \
    android.hardware.memtrack-service-nvidia
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
ifeq ($(TARGET_TEGRA_POWER),perfmgr)
PRODUCT_PACKAGES += \
    android.hardware.power-service.lineage-libperfmgr \
    powerhint.json

PRODUCT_SOONG_NAMESPACES += \
    hardware/google/interfaces \
    hardware/google/pixel \
    hardware/lineage/interfaces/power-libperfmgr

PRODUCT_COPY_FILES += \
    device/nvidia/tegra-common/initfiles/perfmgr.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/perfmgr.rc

ifneq ($(TARGET_TEGRA_PHS),)
$(error Perfmgr and ussr/phs are incompatible)
endif
else ifneq ($(filter $(TARGET_TEGRA_POWER), aosp lineage),)
TARGET_POWERHAL_VARIANT := tegra
PRODUCT_PACKAGES += \
    android.hardware.power-service-nvidia
endif

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
    device/nvidia/tegra-common/seccomp/mediacodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/nvidia/tegra-common/seccomp/mediaextractor.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy
ifneq ($(filter 3.10 4.9 5.10, $(TARGET_KERNEL_VERSION)),)
PRODUCT_COPY_FILES += \
    device/nvidia/tegra-common/seccomp/mediaswcodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaswcodec.policy
endif

ifneq ($(TARGET_TEGRA_SENSORS),)
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-service \
    android.hardware.sensors@1.0-impl \
    $(foreach module,$(TARGET_TEGRA_SENSORS),sensors.$(module))

TARGET_TEGRA_SENSOR_FEATURES ?= accelerometer gyroscope
PRODUCT_COPY_FILES += \
    $(foreach feature,$(TARGET_TEGRA_SENSOR_FEATURES),frameworks/native/data/etc/android.hardware.sensor.$(feature).xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.$(feature).xml)

ifneq ($(filter iio, $(TARGET_TEGRA_SENSORS)),)
PRODUCT_SOONG_NAMESPACES += hardware/intel/sensors-iio
endif
endif

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
else ifeq ($(TARGET_TEGRA_TOS),trusty)
$(call inherit-product, system/core/trusty/trusty-base.mk)
$(call inherit-product, system/core/trusty/trusty-storage.mk)
endif

# TV Input
ifeq ($(PRODUCT_IS_ATV),true)
ifeq ($(shell expr $(TARGET_TEGRA_MAN_LVL) \>= 7), 1)
PRODUCT_PACKAGES += \
    android.hardware.tv.input-service.example
else
PRODUCT_PACKAGES += \
    android.hardware.tv.input@1.0-impl
endif
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
ifeq ($(shell expr $(TARGET_TEGRA_MAN_LVL) \<= 7), 1)
PRODUCT_PACKAGES += \
    android.hardware.usb@1.3-service.basic
endif

# Virtualization (AVF)
ifeq ($(shell expr $(TARGET_TEGRA_MAN_LVL) \>= 202404), 1)
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)
endif

# Wifi
ifneq ($(TARGET_TEGRA_WIFI),)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

ifneq ($(filter $(TARGET_TEGRA_WIFI), bcm),)
PRODUCT_COPY_FILES += \
    device/nvidia/tegra-common/comms/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    device/nvidia/tegra-common/comms/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd \
    wificond \
    libwpa_client \
    wpa_supplicant \
    wpa_supplicant.conf
else
PRODUCT_PACKAGES += \
    com.android.hardware.wpa_supplicant
endif
endif
