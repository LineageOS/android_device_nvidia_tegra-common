LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE           := libnvos_shim
LOCAL_SRC_FILES        := nvos_shim.cpp
LOCAL_SHARED_LIBRARIES := libnvos
LOCAL_VENDOR_MODULE    := true
include $(BUILD_SHARED_LIBRARY)
