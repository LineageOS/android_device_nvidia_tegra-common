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

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE     := libinit_tegra
LOCAL_C_INCLUDES := system/core/init \
                    system/core/base/include
LOCAL_SRC_FILES  := init_tegra.cpp

ifeq ($(WITH_TWRP),true)
LOCAL_CFLAGS     += -DIS_RECOVERY
endif

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES              := init_tegra_vendor.cpp \
                                vendor_tegra.cpp
LOCAL_MODULE                 := init_tegra
LOCAL_INIT_RC                := init_tegra.rc
LOCAL_SHARED_LIBRARIES       := \
    libcutils \
    liblog
LOCAL_WHOLE_STATIC_LIBRARIES := $(TARGET_INIT_VENDOR_LIB)_vendor
LOCAL_VENDOR_MODULE          := true
include $(BUILD_EXECUTABLE)
