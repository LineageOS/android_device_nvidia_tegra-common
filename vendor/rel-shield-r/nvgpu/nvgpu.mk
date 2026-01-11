# Copyright (C) 2020 The LineageOS Project
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

ifeq ($(TARGET_ARCH),arm)
ifneq ($(filter video, $(TARGET_TEGRA_DOLBY)),)
$(error NvGPU on Armv7 is only supported with dolby enabled)
endif
endif

NVGPU_HDCP_PATH := vendor/nvidia/common/rel-shield-r/nvgpu

# Soong namespace for gralloc workaround
PRODUCT_SOONG_NAMESPACES += hardware/interfaces

# Enable gralloc mutex unlock workaround for nvgpu driver deadlock fix
$(call soong_config_set_bool,tegra_gralloc,unlock_before_hal_free,true)

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl \
    vendor.nvidia.hardware.graphics.composer@2.0-service \
    gralloc.tegra \
    vulkan.tegra \
    libEGL_tegra \
    libGLESv1_CM_tegra \
    libGLESv2_tegra \
    libnvsi_ll_2

# Hdcp
PRODUCT_COPY_FILES += \
    $(NVGPU_HDCP_PATH)/etc/hdcpsrm/hdcp1x.srm:$(TARGET_COPY_OUT_VENDOR)/etc/hdcpsrm/hdcp1x.srm \
    $(NVGPU_HDCP_PATH)/etc/hdcpsrm/hdcp2x.srm:$(TARGET_COPY_OUT_VENDOR)/etc/hdcpsrm/hdcp2x.srm \
    $(NVGPU_HDCP_PATH)/etc/hdcpsrm/hdcp2xtest.srm:$(TARGET_COPY_OUT_VENDOR)/etc/hdcpsrm/hdcp2xtest.srm

# Overlays
PRODUCT_PACKAGES += \
    SimpleSettingsNvgpuOverlay \
    TvSettingsNvgpuOverlay

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2020-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196610 \
    persist.vendor.tegra.compression=off \
    persist.vendor.tegra.decompression=cde-client \
    ro.vendor.tegra.AF73C63E=0x80007ffd \
    vendor.tegra.0x523dd1=2 \
    ro.vendor.tegra.yuv.cpu_min=-1 \
    ro.vendor.tegra.yuv.cpu_max=-1 \
    ro.vendor.tegra.yuv.cpu_pri=15 \
    ro.vendor.tegra.yuv.gpu_min=691200 \
    ro.vendor.tegra.yuv.gpu_max=-1 \
    ro.vendor.tegra.yuv.gpu_pri=15 \
    ro.vendor.tegra.yuv.emc_min=106560 \
    ro.vendor.tegra.glc.cpu_min=-1 \
    ro.vendor.tegra.glc.cpu_max=-1 \
    ro.vendor.tegra.glc.cpu_pri=15 \
    ro.vendor.tegra.glc.gpu_min=614400 \
    ro.vendor.tegra.glc.gpu_max=-1 \
    ro.vendor.tegra.glc.gpu_pri=15 \
    ro.vendor.tegra.glc.emc_min=4080 \
    ro.surface_flinger.vsync_event_phase_offset_ns=100000 \
    ro.surface_flinger.vsync_sf_event_phase_offset_ns=100000 \
    debug.sf.high_fps_late_app_phase_offset_ns=100000 \
    debug.sf.high_fps_late_sf_phase_offset_ns=100000 \
    ro.lib_gui.buffer_dequeue_timeout_ms=500 \
    ro.lib_gui.fence_timeout_ms=1000

ifneq ($(filter video, $(TARGET_TEGRA_DOLBY)),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.tegra.deepisp.cpu_min=-1 \
    ro.vendor.tegra.deepisp.cpu_max=-1 \
    ro.vendor.tegra.deepisp.cpu_pri=15 \
    ro.vendor.tegra.deepisp.gpu_min=1075200 \
    ro.vendor.tegra.deepisp.gpu_max=-1 \
    ro.vendor.tegra.deepisp.gpu_pri=15 \
    ro.vendor.tegra.deepisp.emc_min=106560
endif

# composite-yuv is broken without fw patches,
# assign-windows is broken on non-atv
ifeq ($(NV_ANDROID_FRAMEWORK_ENHANCEMENTS),true)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.tegra.composite.policy=composite-yuv
else
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.tegra.composite.policy=assign-windows
endif
