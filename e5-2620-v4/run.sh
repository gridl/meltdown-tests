#!/bin/sh

s1=noretpoline
s2=pti
s3=pcid

c=`grep ' pti ' /proc/cpuinfo | wc -l`

if [ "$c" == "0" ]; then
        s2=nopti
fi

c=`grep ' pcid ' /proc/cpuinfo | wc -l`

if [ "$c" == "0" ]; then
        s3=nopcid
fi

c=`cat /sys/devices/system/cpu/vulnerabilities/spectre_v2`

if [ "$c" == "Vulnerable" ]; then
	s1="noretpoline";
elif [ "$c" == "Mitigation: Full generic retpoline" ]; then
	s1="retpoline";
else
	echo "invalid retpoline value: $c"
	exit 1
fi


type="$s1-$s2-$s3"


if [ -d "$type" ]; then
	echo "directory $type already exists"
	exit 2
fi

mkdir $type

rm -f stop_stats

./info.sh $type

./stats.sh $type 2> /dev/null &

./run-pgbench.sh $type

./run-tpch-tests.sh $type

touch stop_stats

