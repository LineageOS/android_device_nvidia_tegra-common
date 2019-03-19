#!/vendor/bin/sh
#
# Copyright (c) 2015-2018 NVIDIA Corporation.  All rights reserved.
#
# NVIDIA Corporation and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA Corporation is strictly prohibited.
#

# Read the Board/Platform name
hardwareName=$(getprop ro.hardware)

# set sys.usb.configfs as 0 kernel 3.10 and 1 otherwise
k310=$(cat /proc/version | grep "Linux version 3.10")
if [ "$k310" != "" ]; then
	setprop sys.usb.ffs.aio_compat 1
	setprop persist.adb.nonblocking_ffs 0
	setprop ro.adb.nonblocking_ffs 0
	setprop sys.usb.configfs 0
else
	setprop sys.usb.configfs 1
fi

# Enable ADB if the "safe mode w/ adb" DT node is present
usbPortPath=/sys/class/extcon/extcon3/state
safeModeDTPath=/proc/device-tree/chosen/nvidia,safe_mode_adb
deviceModeVal=0x1
hostModeVal=0x2

ls $safeModeDTPath
if [[ $? -eq 0 ]]; then # Safe Mode w/ ADB
	# Init the USB to "device" mode only for Darcy SKUs
	if [[ $hardwareName = *"darcy"* ]]; then
		echo $deviceModeVal > $usbPortPath
	fi

	# Append adb to the usb config in normal boot mode
	currConfig=$(getprop persist.sys.usb.config)
	if [[ -z $currConfig ]]; then
		setprop vendor.config.usb adb
	elif [[ $currConfig != *"adb"* ]]; then
		setprop vendor.config.usb $currConfig,adb
	else
		setprop vendor.config.usb $currConfig
	fi
else # All other Modes
	# Init the USB to default mode only for Darcy SKUs
	if [[ $hardwareName = *"darcy"* ]]; then
		if [[ $(getprop persist.vendor.convertible.usb.mode) == "host" ]]; then
			echo $hostModeVal > $usbPortPath
		fi
	fi

	# Assign the persistent USB config; if it exists
	currConfig=$(getprop persist.sys.usb.config)
	if [[ ! -z "$currConfig" ]]; then
		setprop vendor.config.usb $currConfig
	fi
fi
