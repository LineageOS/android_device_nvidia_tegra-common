LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.comms.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.comms.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.gps.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.gps.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.hdcp.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.hdcp.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.lkm.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.lkm.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.none.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.none.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.tegra.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.tegra.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.tegra_emmc.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.tegra_emmc.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.tegra_sata.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.tegra_sata.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.tegra_sd.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.tegra_sd.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.tf.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.tf.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.tlk.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.tlk.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.xusb.configfs.usb.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.xusb.configfs.usb.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.nv_dev_board.usb.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.nv_dev_board.usb.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE               := init.sata.configs.rc
LOCAL_MODULE_CLASS         := ETC
LOCAL_SRC_FILES            := init.sata.configs.rc
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.recovery.usb.rc
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := init.recovery.usb.rc
LOCAL_MODULE_PATH  := $(TARGET_ROOT_OUT)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := wifi_loader
LOCAL_SRC_FILES     := wifi_loader.sh
LOCAL_MODULE_SUFFIX := .sh
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_MODULE_OWNER  := nvidia
LOCAL_VENDOR_MODULE := true
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := bt_loader
LOCAL_SRC_FILES     := bt_loader.sh
LOCAL_MODULE_SUFFIX := .sh
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_MODULE_OWNER  := nvidia
LOCAL_VENDOR_MODULE := true
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := lkm_loader
LOCAL_SRC_FILES     := lkm_loader.sh
LOCAL_MODULE_SUFFIX := .sh
LOCAL_MODULE_CLASS  := EXECUTABLES
LOCAL_VENDOR_MODULE := true
include $(BUILD_PREBUILT)
