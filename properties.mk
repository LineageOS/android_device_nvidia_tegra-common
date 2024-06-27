# Bluetooth
ifneq ($(TARGET_TEGRA_BT),)
PRODUCT_PROPERTY_OVERRIDES += \
    bluetooth.profile.asha.central.enabled?=true \
    bluetooth.profile.a2dp.source.enabled?=true \
    bluetooth.profile.avrcp.target.enabled?=true \
    bluetooth.profile.gatt.enabled?=true \
    bluetooth.profile.hid.host.enabled?=true
ifneq ($(PRODUCT_IS_ATV),true)
PRODUCT_PROPERTY_OVERRIDES += \
    bluetooth.profile.bas.client.enabled?=true \
    bluetooth.profile.hfp.ag.enabled?=true \
    bluetooth.profile.hid.device.enabled?=true \
    bluetooth.profile.map.server.enabled?=true \
    bluetooth.profile.opp.enabled?=true \
    bluetooth.profile.pan.nap.enabled?=true \
    bluetooth.profile.pan.panu.enabled?=true \
    bluetooth.profile.pbap.server.enabled?=true \
    bluetooth.profile.sap.server.enabled?=true
endif
ifneq ($(filter bcm, $(TARGET_TEGRA_BT)),)
PRODUCT_PROPERTY_OVERRIDES += \
    bluetooth.core.gap.le.privacy.enabled=false
endif
endif

# CEC
ifneq ($(TARGET_TEGRA_CEC),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hdmi.device_type=4 \
    persist.sys.hdmi.keep_awake=0 \
    ro.hdmi.wake_on_hotplug=0
endif

# DRM
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true

# fastbootd
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.fastbootd.available=true

# Graphics
ifeq ($(TARGET_TEGRA_GPU),drm)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196610 \
    ro.hardware.gralloc=minigbm \
    ro.hardware.hwcomposer=drm \
    ro.hardware.egl=mesa \
    gralloc.gbm.device=/dev/dri/renderD129 \
    vendor.hwc.drm.device=/dev/dri/card1 \
    drm.gpu.vendor_name=tegra
else ifeq ($(TARGET_TEGRA_GPU),swiftshader)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.gralloc=minigbm \
    ro.hardware.hwcomposer=drm_minigbm \
    ro.hardware.egl=angle \
    ro.hardware.vulkan=pastel
endif

# LMKD
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lmk.kill_heaviest_task=true

# USB
ifneq ($(filter $(TARGET_TEGRA_KERNEL), 3.4 3.10),)
PRODUCT_PROPERTY_OVERRIDES += \
    sys.usb.ffs.aio_compat=1 \
    persist.adb.nonblocking_ffs=0 \
    ro.adb.nonblocking_ffs=0
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.lineage.tegra.configfs=1
endif

# WiFi
ifneq ($(TARGET_TEGRA_WIFI),)
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.direct.interface=p2p-dev-wlan0 \
    wifi.interface=wlan0
endif
