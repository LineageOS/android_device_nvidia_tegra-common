# Bluetooth
ifneq ($(TARGET_BLUETOOTH_HAL),)
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
endif

# CEC
ifneq ($(TARGET_TV_HDMI_CEC_HAL),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hdmi.device_type=4 \
    persist.sys.hdmi.keep_awake=0 \
    ro.hdmi.wake_on_hotplug=0
endif

# Disable debug and verbose logging by default
ifneq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += log.tag=I
endif

# DRM
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true

# fastbootd
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.fastbootd.available=true

# Graphics
ifeq ($(TARGET_GRAPHICS),mesa)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196610
endif

# Media
PRODUCT_PROPERTY_OVERRIDES += \
    media.c2.hal.selection=aidl \
    debug.stagefright.c2inputsurface=-1

# Thermal
ifeq ($(TARGET_THERMAL_HAL),linaro-libpm)
PRODUCT_VENDOR_PROPERTIES += \
    vendor.thermal.config=thermal-$(TARGET_TEGRA_VERSION).json
endif
