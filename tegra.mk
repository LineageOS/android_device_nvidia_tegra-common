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

# Ramdisk
PRODUCT_PACKAGES += \
    adbenable \
    init.comms.rc \
    init.data_bin.rc \
    init.hdcp.rc \
    init.none.rc \
    init.nv_dev_board.usb.rc \
    init.recovery.nv_dev_board.usb.rc \
    init.recovery.xusb.configfs.usb.rc \
    init.sata.configs.rc \
    init.tegra.rc \
    init.tegra_emmc.rc \
    init.tegra_sata.rc \
    init.tegra_sd.rc \
    init.xusb.configfs.usb.rc

PRODUCT_COPY_FILES += \
    system/core/rootdir/init.usb.configfs.rc:$(TARGET_COPY_OUT_ROOT)/init.recovery.usb.configfs.rc
