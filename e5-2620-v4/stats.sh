#!/bin/sh

OUTDIR=$1

echo "now|timestamp|wal_bytes|datid|datname|numbackends|xact_commit|xact_rollback|blks_read|blks_hit|tup_returned|tup_fetched|tup_inserted|tup_updated|tup_deleted|conflicts|temp_files|temp_bytes|deadlocks|blk_read_time|blk_write_time|stats_reset" > $OUTDIR/stats.csv

ts=`psql -t -A -c "select extract(epoch from now())" postgres`
i=1

while /bin/true; do

	if [ -f "stop_stats" ]; then
		rm stop_stats
		break
	fi

	psql postgres -t -A -c "select now(), extract(epoch from now()), pg_wal_lsn_diff(pg_current_wal_lsn(), '0/0'), * from pg_stat_database where datname = 'test'" >> $OUTDIR/stats.csv 2>&1

	psql postgres -c "select pg_sleep($ts + $i - extract(epoch from now()))" > /dev/null 2>&1

	i=$((i+1))

done

