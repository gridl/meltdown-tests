RO_TIME=300
RW_TIME=1800
RUNS=3

OUTDIR="$1/pgbench"

function log_message
{
        m=$1

	echo `date +'%Y-%m-%d %H:%M:%S'` : $m
}

for s in 100 1000 10000; do

        mkdir -p $OUTDIR/$s/runs

        dropdb test
        createdb test

        echo "===== scale $s ====="

        pgbench -i -s $s test > $OUTDIR/$s/init-$s.log 2>&1

        psql test -c "vacuum analyze" test >> $OUTDIR/$s/vacuum.log 2>&1
        psql test -c "checkpoint" test >> $OUTDIR/$s/checkpoint.log 2>&1

        # read-only tests
        for r in `seq 1 $RUNS`; do

                log_message "read-only run $r"
                pgbench -n -c 16 -j 16 -S -T $RO_TIME test | tee $OUTDIR/$s/runs/result-ro-$r.log | grep including | awk '{print $3}' >> $OUTDIR/$s/results-ro.log 2>&1

        done

	for r in `seq 1 $RUNS`; do

                log_message "read-only run $r (prepared)"
                pgbench -n -c 16 -j 16 -S -M prepared -T $RO_TIME test | tee $OUTDIR/$s/runs/result-ro-prepared-$s-$r.log | grep including | awk '{print $3}' >> $OUTDIR/$s/results-ro-prepared.log 2>&1

        done

	# read-write tests
        psql test -c "checkpoint" test >> $OUTDIR/$s/checkpoint.log 2>&1

        for r in `seq 1 $RUNS`; do

                log_message "read-write run $r"
                pgbench -n -c 16 -j 16 -N -T $RW_TIME test | tee $OUTDIR/$s/runs/result-rw-$r.log | grep including | awk '{print $3}' >> $OUTDIR/$s/results-rw.log 2>&1

        done

	psql test -c "checkpoint" test >> $OUTDIR/$s/checkpoint.log 2>&1

        for r in `seq 1 $RUNS`; do

                log_message "read-write run $r (prepared)"
                pgbench -n -c 16 -j 16 -N -T $RW_TIME -M prepared test | tee $OUTDIR/$s/runs/result-rw-prepared-$s-$r.log | grep including | awk '{print $3}' >> $OUTDIR/$s/results-rw-prepared.log 2>&1

        done

	dropdb test

done

