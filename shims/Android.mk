LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE           := libkeymaster_shim
LOCAL_SRC_FILES        := keymaster_shim.cpp
LOCAL_VENDOR_MODULE    := true
include $(BUILD_SHARED_LIBRARY)
