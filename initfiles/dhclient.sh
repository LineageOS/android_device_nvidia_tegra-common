#!/system/bin/sh

if [ -f "/sys/class/net/${1}/operstate" ]; then
  # Give time for ifup to settle
  sleep 5;

  if [ "$(cat /sys/class/net/${1}/operstate)" == "up" ]; then
    exec /system/bin/dhcpclient -i ${1};
  fi;
fi;

# If device not present or unplugged, set done and carry on
setprop vendor.net.${1}.dhcp_done 1;
