COPY customer FROM PROGRAM 'gunzip -c /mnt/raid/tpch-50/customer.csv.gz' WITH (FORMAT csv, DELIMITER '|');
COPY lineitem FROM PROGRAM 'gunzip -c /mnt/raid/tpch-50/lineitem.csv.gz' WITH (FORMAT csv, DELIMITER '|');
COPY nation FROM PROGRAM 'gunzip -c /mnt/raid/tpch-50/nation.csv.gz' WITH (FORMAT csv, DELIMITER '|');
COPY orders FROM PROGRAM 'gunzip -c /mnt/raid/tpch-50/orders.csv.gz' WITH (FORMAT csv, DELIMITER '|');
COPY partsupp FROM PROGRAM 'gunzip -c /mnt/raid/tpch-50/partsupp.csv.gz' WITH (FORMAT csv, DELIMITER '|');
COPY part FROM PROGRAM 'gunzip -c /mnt/raid/tpch-50/part.csv.gz' WITH (FORMAT csv, DELIMITER '|');
COPY region FROM PROGRAM 'gunzip -c /mnt/raid/tpch-50/region.csv.gz' WITH (FORMAT csv, DELIMITER '|');
COPY supplier FROM PROGRAM 'gunzip -c /mnt/raid/tpch-50/supplier.csv.gz' WITH (FORMAT csv, DELIMITER '|');

