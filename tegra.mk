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

TARGET_TEGRA_HEALTH ?= common

# Enable nvidia framework enhancements if available
-include vendor/lineage/product/nvidia.mk

# System properties
include $(LOCAL_PATH)/system_prop.mk

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    device/nvidia/tegra-common/overlay

# Ramdisk
PRODUCT_PACKAGES += \
    adbenable \
    bt_loader \
    wifi_loader \
    init.comms.rc \
    init.data_bin.rc \
    init.hdcp.rc \
    init.none.rc \
    init.nv_dev_board.usb.rc \
    init.recovery.nv_dev_board.usb.rc \
    init.recovery.xusb.configfs.usb.rc \
    init.sata.configs.rc \
    init.tegra.rc \
    init.tegra_emmc.rc \
    init.tegra_sata.rc \
    init.tegra_sd.rc \
    init.xusb.configfs.usb.rc

PRODUCT_COPY_FILES += \
    system/core/rootdir/init.usb.configfs.rc:$(TARGET_COPY_OUT_ROOT)/init.recovery.usb.configfs.rc

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

# Audio
ifeq ($(TARGET_TEGRA_AUDIO),nvaudio)
PRODUCT_PACKAGES += \
    a2dp_module_deviceports.xml \
    a2dp_module_mixports.xml \
    primary_module_deviceports.xml \
    primary_module_mixports.xml \
    r_submix_audio_policy_configuration.xml \
    usb_module_deviceports.xml \
    usb_module_mixports.xml \
    ne_audio_policy_volumes.xml \
    ne_default_volume_tables.xml

ifeq ($(TARGET_TEGRA_DOLBY),true)
PRODUCT_PACKAGES += \
    msd_audio_policy_configuration.xml
endif
endif

# Bluetooth
ifneq ($(TARGET_TEGRA_BT),)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

ifeq ($(TARGET_TEGRA_BT),bcm)
PRODUCT_PACKAGES += \
    libbt-vendor \
    android.hardware.bluetooth@1.0-service \
    android.hardware.bluetooth@1.0-impl
else ifeq ($(TARGET_TEGRA_BT),btlinux)
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-service.btlinux
endif
endif

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

# Memtrack
ifeq ($(TARGET_TEGRA_MEMTRACK),lineage)
PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-service-nvidia
endif

# PHS
ifeq ($(TARGET_TEGRA_PHS),nvphs)
PRODUCT_PACKAGES += \
    init.nvphsd_setup.rc \
    nvphsd.rc \
    nvphsd_common.conf \
    nvphsd_setup.sh
endif

# Power
ifeq ($(TARGET_TEGRA_POWER),lineage)
TARGET_POWERHAL_VARIANT := tegra
PRODUCT_PACKAGES += \
    vendor.nvidia.hardware.power@1.0-service
endif

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
    device/nvidia/tegra-common/seccomp/mediacodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/nvidia/tegra-common/seccomp/mediaextractor.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

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
