CREATE DATABASE IF NOT EXISTS dwh ON CLUSTER dwh_cluster;

CREATE TABLE dwh.electricity_local ON CLUSTER dwh_cluster
(
  lclid LowCardinality(String),
  tariff LowCardinality(String),
  ts DateTime,
  kwh Float32,
  hour UInt8,
  year UInt16,
  month UInt8,
  day UInt8,
  day_name LowCardinality(String),
  consumption_category LowCardinality(String)
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(ts)
ORDER BY (lclid, ts);

CREATE TABLE dwh.electricity ON CLUSTER dwh_cluster
AS dwh.electricity_local
ENGINE = Distributed(dwh_cluster, dwh, electricity_local, cityHash64(lclid));