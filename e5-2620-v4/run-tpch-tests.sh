#!/bin/sh

workers=0
maxworkers=0

type=$1

for dbname in tpch-10 tpch-50; do

    if [ -d "$type/$dbname" ]; then
        echo "$type/$dbname already exists"
    fi

    mkdir "$type/$dbname"

    ./run-tpch.sh "$type/$dbname" $workers $maxworkers $dbname > "$type/$dbname"/tpch.log 2>&1

    cat /proc/cpuinfo > $type/$dbname/cpuinfo.txt 2>&1

    dmesg > "$type/$dbname"/dmesg.txt 2>&1

done

