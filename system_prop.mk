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

# WiFi
ifneq ($(TARGET_TEGRA_WIFI),)
PRODUCT_PROPERTY_OVERRIDES += \
    ap.interface=wlan0 \
    wifi.direct.interface=p2p-dev-wlan0 \
    wifi.interface=wlan0
endif
