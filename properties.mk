# LMKd
PRODUCT_PRODUCT_PROPERTIES += \
    ro.lmk.low=1001 \
    ro.lmk.medium=800 \
    ro.lmk.critical=0 \
    ro.lmk.critical_upgrade=false \
    ro.lmk.upgrade_pressure=100 \
    ro.lmk.downgrade_pressure=100 \
    ro.lmk.kill_heaviest_task=true \
    ro.lmk.kill_timeout_ms=100 \
    ro.lmk.use_minfree_levels=true

# CEC
ifneq ($(TARGET_TEGRA_CEC),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hdmi.device_type=4 \
    persist.sys.hdmi.keep_awake=0
endif
ifneq ($(TARGET_TEGRA_CEC),aosp)
    ro.hdmi.wake_on_hotplug=0
endif

# Graphics
ifeq ($(TARGET_TEGRA_GPU),drm)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196610 \
    ro.hardware.gralloc=gbm \
    ro.hardware.hwcomposer=drm \
    gralloc.gbm.device=/dev/dri/renderD129 \
    hwc.drm.device=/dev/dri/card1 \
    drm.gpu.vendor_name=tegra
endif

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
    ap.interface=wlan0 \
    wifi.direct.interface=p2p-dev-wlan0 \
    wifi.interface=wlan0
endif
