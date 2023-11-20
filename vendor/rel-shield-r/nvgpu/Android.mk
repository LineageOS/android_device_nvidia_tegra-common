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

ifeq ($(TARGET_TEGRA_GPU),rel-shield-r)
LOCAL_PATH := $(call my-dir)
COMMON_NVGPU_PATH := ../../../../../../vendor/nvidia/common/rel-shield-r/nvgpu

include $(CLEAR_VARS)
LOCAL_MODULE               := vendor.nvidia.hardware.graphics.composer@2.0-service
LOCAL_VINTF_FRAGMENTS      := vendor.nvidia.hardware.graphics.composer@2.0-service.xml
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/bin32/hw/vendor.nvidia.hardware.graphics.composer@2.0-service
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/bin64/hw/vendor.nvidia.hardware.graphics.composer@2.0-service
LOCAL_MULTILIB             := first
LOCAL_INIT_RC              := etc/init/vendor.nvidia.hardware.graphics.composer@2.0-service.rc
LOCAL_MODULE_CLASS         := EXECUTABLES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := hdcp1x
LOCAL_SRC_FILES            := $(COMMON_NVGPU_PATH)/etc/hdcpsrm/hdcp1x.srm
LOCAL_MODULE_SUFFIX        := .srm
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hdcpsrm
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := hdcp2x
LOCAL_SRC_FILES            := $(COMMON_NVGPU_PATH)/etc/hdcpsrm/hdcp2x.srm
LOCAL_MODULE_SUFFIX        := .srm
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hdcpsrm
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := hdcp2xtest
LOCAL_SRC_FILES            := $(COMMON_NVGPU_PATH)/etc/hdcpsrm/hdcp2xtest.srm
LOCAL_MODULE_SUFFIX        := .srm
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hdcpsrm
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := gralloc.tegra
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/hw/gralloc.tegra.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/hw/gralloc.tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vulkan.tegra
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/hw/vulkan.tegra.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/hw/vulkan.tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libEGL_tegra
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/egl/libEGL_tegra.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/egl/libEGL_tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := egl
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libGLESv1_CM_tegra
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/egl/libGLESv1_CM_tegra.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/egl/libGLESv1_CM_tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := egl
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libGLESv2_tegra
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/egl/libGLESv2_tegra.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/egl/libGLESv2_tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := egl
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libdolbycontrol
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libdolbycontrol.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libdolbycontrol.so
LOCAL_MULTILIB             := first
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libglcore
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libglcore.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libglcore.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_REQUIRED_MODULES     := com.nvidia.feature.opengl4.xml
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libmempoollocal
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libmempoollocal.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libmempoollocal.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvblit
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvblit.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvblit.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvddk_2d_v2
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvddk_2d_v2.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvddk_2d_v2.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvddk_vic
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvddk_vic.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvddk_vic.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvglsi
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvglsi.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvglsi.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_REQUIRED_MODULES     := libnvwsi
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvgr
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvgr.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvgr.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvhwcomposer
LOCAL_REQUIRED_MODULES     := libcuda
ifneq ($(filter video, $(TARGET_TEGRA_DOLBY)),)
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvhwcomposer.dolby.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvhwcomposer.dolby.so
LOCAL_REQUIRED_MODULES     += libdolbycontrol
else
# 32-bit non-dolby binary doesn't exist, but this needs to be here for parsing purposes
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvhwcomposer.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvhwcomposer.so
endif
LOCAL_MULTILIB             := first
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvidia-glvkspirv
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvidia-glvkspirv.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvidia-glvkspirv.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvrmapi_tegra
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvrmapi_tegra.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvrmapi_tegra.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvrm_chip
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvrm_chip.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvrm_chip.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvrm_gpu
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvrm_gpu.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvrm_gpu.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvrm_host1x
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvrm_host1x.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvrm_host1x.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvrm_mem
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvrm_mem.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvrm_mem.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvrm_stream
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvrm_stream.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvrm_stream.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvrm_surface
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvrm_surface.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvrm_surface.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvrm_sync
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvrm_sync.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvrm_sync.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvrmvkif
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvrmvkif.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvrmvkif.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvwsi
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvwsi.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvwsi.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvcolorutil
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvcolorutil.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvcolorutil.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvdc
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvdc.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvdc.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvimp
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvimp.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvimp.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libcuda
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libcuda.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libcuda.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_REQUIRED_MODULES     := libnvcucompat libnvidia-ptxjitcompiler
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvcucompat
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvcucompat.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvcucompat.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvsocsys
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvsocsys.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvsocsys.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvidia-ptxjitcompiler
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvidia-ptxjitcompiler.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvidia-ptxjitcompiler.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vendor.nvidia.hardware.graphics.composer@2.0-impl
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/vendor.nvidia.hardware.graphics.composer@2.0-impl.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/vendor.nvidia.hardware.graphics.composer@2.0-impl.so
LOCAL_MULTILIB             := first
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vendor.nvidia.hardware.graphics.display@1.0-impl
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/vendor.nvidia.hardware.graphics.display@1.0-impl.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/vendor.nvidia.hardware.graphics.display@1.0-impl.so
LOCAL_MULTILIB             := first
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := vendor.nvidia.hardware.graphics.mempool@1.0-impl
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/vendor.nvidia.hardware.graphics.mempool@1.0-impl.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/vendor.nvidia.hardware.graphics.mempool@1.0-impl.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := com.nvidia.feature.opengl4.xml
LOCAL_SRC_FILES            := etc/permissions/com.nvidia.feature.opengl4.xml
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := permissions
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libtlk_secure_hdcp_up
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libtlk_secure_hdcp_up.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libtlk_secure_hdcp_up.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libtsechdcp
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libtsechdcp.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libtsechdcp.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libtsec_wrapper
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libtsec_wrapper.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libtsec_wrapper.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := libnvsi_ll_2
LOCAL_SRC_FILES_32         := $(COMMON_NVGPU_PATH)/lib/libnvsi_ll_2.so
LOCAL_SRC_FILES_64         := $(COMMON_NVGPU_PATH)/lib64/libnvsi_ll_2.so
LOCAL_MULTILIB             := both
LOCAL_MODULE_SUFFIX        := .so
LOCAL_MODULE_CLASS         := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER         := nvidia
LOCAL_VENDOR_MODULE        := true
include $(BUILD_NVIDIA_COMMON_PREBUILT)
endif
