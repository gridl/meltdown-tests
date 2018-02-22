ALTER TABLE supplier ADD CONSTRAINT pk_supplier PRIMARY KEY (s_suppkey);
CREATE INDEX supplier_s_suppkey_idx_like ON supplier (s_suppkey) WHERE s_comment LIKE '%Customer%Complaints%';
CREATE INDEX supplier_s_nationkey_s_suppkey_idx ON supplier (s_nationkey, s_suppkey);

ALTER TABLE part ADD CONSTRAINT pk_part PRIMARY KEY (p_partkey);
CREATE INDEX part_p_type_p_partkey_idx ON part(p_type, p_partkey);
CREATE INDEX part_p_container_p_brand_p_partkey_idx ON part(p_container, p_brand, p_partkey);
CREATE INDEX part_p_size_idx ON part(p_size);
CREATE INDEX part_p_name_idx ON part(p_name);

ALTER TABLE partsupp ADD CONSTRAINT pk_partsupp PRIMARY KEY (ps_partkey, ps_suppkey);
CREATE INDEX partsupp_ps_suppkey_idx ON partsupp (ps_suppkey);

ALTER TABLE customer ADD CONSTRAINT pk_customer PRIMARY KEY (c_custkey);
CREATE INDEX customer_c_nationkey_c_custkey_idx ON customer (c_nationkey, c_custkey);
CREATE INDEX customer_c_phone_idx_c_acctbal ON customer (substr(c_phone::text, 1, 2)) WHERE c_acctbal > 0.00;
CREATE INDEX customer_c_phone_idx ON customer (substr(c_phone::text, 1, 2), c_acctbal);
CREATE INDEX customer_c_mktsegment_c_custkey_idx ON customer (c_mktsegment, c_custkey);

ALTER TABLE orders ADD CONSTRAINT pk_orders PRIMARY KEY (o_orderkey);
CREATE INDEX orders_o_orderdate_o_orderkey_idx ON orders (o_orderdate, o_orderkey);
CREATE INDEX orders_o_orderkey_o_orderdate_idx ON orders (o_orderkey, o_orderdate);

ALTER TABLE lineitem ADD CONSTRAINT pk_lineitem PRIMARY KEY (l_orderkey, l_linenumber);
CREATE INDEX lineitem_l_partkey_l_quantity_l_shipmode_idx ON lineitem (l_partkey, l_quantity, l_shipmode);
CREATE INDEX lineitem_l_orderkey_idx ON lineitem (l_orderkey);
CREATE INDEX lineitem_l_orderkey_idx_l_returnflag ON lineitem (l_orderkey) WHERE l_returnflag = 'R';
CREATE INDEX lineitem_l_orderkey_idx_part1 ON lineitem (l_orderkey) WHERE l_commitdate < l_receiptdate;
CREATE INDEX lineitem_l_orderkey_idx_part2 ON lineitem (l_orderkey) WHERE l_commitdate < l_receiptdate   AND l_shipdate < l_commitdate;
CREATE INDEX lineitem_l_shipdate_l_suppkey__idx ON lineitem (l_shipdate, l_suppkey);
CREATE INDEX lineitem_l_orderkey_l_linenumber_l_shipdate_idx ON lineitem (l_orderkey, l_linenumber, l_shipdate);

ALTER TABLE nation ADD CONSTRAINT pk_nation PRIMARY KEY (n_nationkey);

ALTER TABLE region ADD CONSTRAINT pk_region PRIMARY KEY (r_regionkey);

