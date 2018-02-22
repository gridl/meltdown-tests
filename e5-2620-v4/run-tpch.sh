#!/bin/env bash

OUTDIR=$1
WORKERS=$2
MAXWORKERS=$3
DBNAME=$4

mkdir $OUTDIR

for i in `seq 1 22`; do

    # now 5 runs for each query
    for x in `seq 1 5`; do

	if [ -f "stop_file" ]; then
		exit
	fi

	s=`psql $DBNAME -t -A -c "select extract(epoch from now())"`

	# now run the query
	psql --single-transaction -v ON_ERROR_STOP= $DBNAME >> $OUTDIR/query-$i-$x.log 2>&1 <<EOF

-- terminate query after 30 minutes
SET statement_timeout = 1800000;
SET work_mem = '128MB';
SET max_parallel_workers = $MAXWORKERS;
SET max_parallel_workers_per_gather = $WORKERS;

\o /dev/null

-- run the query
\i queries/$i.sql
EOF

	if [ "$?" == "0" ]; then
		r="SUCCESS"
	else
		r="FAILURE"
	fi

	e=`psql $DBNAME -t -A -c "select extract(epoch from now())"`
	d=`psql $DBNAME -t -A -c "select $e - $s"`

	echo "$e : QUERY $i RUN $x TIME $d : $r"

	sleep 5

    done

done
