#!/bin/sh

type=$1

echo '' > $type/vulnerabilities.info

for v in meltdown spectre_v1 spectre_v2; do

    x=`cat /sys/devices/system/cpu/vulnerabilities/$v`

    echo "$v $x" >> $type/vulnerabilities.info

done


gunzip -c /proc/config.gz > $type/kernel.config

