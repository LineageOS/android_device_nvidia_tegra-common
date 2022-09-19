#!/vendor/bin/sh

while read -r kmod; do
  /vendor/bin/modprobe -a -d /vendor/lib/modules $kmod;
done < /vendor/lib/modules/modules.load
