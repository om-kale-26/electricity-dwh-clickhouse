CREATE DATABASE IF NOT EXISTS star ON CLUSTER dwh_cluster;
CREATE DATABASE IF NOT EXISTS snowflake ON CLUSTER dwh_cluster;
CREATE DATABASE IF NOT EXISTS constellation ON CLUSTER dwh_cluster;

-- ================= STAR =================
CREATE TABLE star.dim_household ON CLUSTER dwh_cluster (household_key UInt32, lclid String) ENGINE=MergeTree ORDER BY household_key;
CREATE TABLE star.dim_date ON CLUSTER dwh_cluster (date_key UInt32, full_date Date, year UInt16, month UInt8, day UInt8, day_name String) ENGINE=MergeTree ORDER BY date_key;
CREATE TABLE star.dim_time ON CLUSTER dwh_cluster (time_key UInt16, hour UInt8, minute UInt8) ENGINE=MergeTree ORDER BY time_key;
CREATE TABLE star.dim_category ON CLUSTER dwh_cluster (category_key UInt8, category_name String) ENGINE=MergeTree ORDER BY category_key;
CREATE TABLE star.fact_consumption_local ON CLUSTER dwh_cluster (date_key UInt32, time_key UInt16, household_key UInt32, category_key UInt8, kwh Float32) ENGINE=MergeTree ORDER BY (household_key, date_key, time_key);
CREATE TABLE star.fact_consumption ON CLUSTER dwh_cluster AS star.fact_consumption_local ENGINE=Distributed(dwh_cluster, star, fact_consumption_local, cityHash64(household_key));

-- ================= SNOWFLAKE =================
CREATE TABLE snowflake.dim_year ON CLUSTER dwh_cluster (year_key UInt16, year UInt16) ENGINE=MergeTree ORDER BY year_key;
CREATE TABLE snowflake.dim_month ON CLUSTER dwh_cluster (month_key UInt32, month UInt8, month_name String, year_key UInt16) ENGINE=MergeTree ORDER BY month_key;
CREATE TABLE snowflake.dim_day_name ON CLUSTER dwh_cluster (day_name_key UInt8, day_name String) ENGINE=MergeTree ORDER BY day_name_key;
CREATE TABLE snowflake.dim_date ON CLUSTER dwh_cluster (date_key UInt32, full_date Date, day UInt8, month_key UInt32, day_name_key UInt8) ENGINE=MergeTree ORDER BY date_key;
CREATE TABLE snowflake.dim_day_part ON CLUSTER dwh_cluster (day_part_key UInt8, day_part String) ENGINE=MergeTree ORDER BY day_part_key;
CREATE TABLE snowflake.dim_hour ON CLUSTER dwh_cluster (hour_key UInt8, hour UInt8, day_part_key UInt8) ENGINE=MergeTree ORDER BY hour_key;
CREATE TABLE snowflake.dim_time ON CLUSTER dwh_cluster (time_key UInt16, minute UInt8, hour_key UInt8) ENGINE=MergeTree ORDER BY time_key;
CREATE TABLE snowflake.dim_household ON CLUSTER dwh_cluster (household_key UInt32, lclid String) ENGINE=MergeTree ORDER BY household_key;
CREATE TABLE snowflake.dim_category ON CLUSTER dwh_cluster (category_key UInt8, category_name String) ENGINE=MergeTree ORDER BY category_key;
CREATE TABLE snowflake.fact_consumption_local ON CLUSTER dwh_cluster (date_key UInt32, time_key UInt16, household_key UInt32, category_key UInt8, kwh Float32) ENGINE=MergeTree ORDER BY (household_key, date_key, time_key);
CREATE TABLE snowflake.fact_consumption ON CLUSTER dwh_cluster AS snowflake.fact_consumption_local ENGINE=Distributed(dwh_cluster, snowflake, fact_consumption_local, cityHash64(household_key));

-- ================= FACT CONSTELLATION =================
CREATE TABLE constellation.dim_household ON CLUSTER dwh_cluster (household_key UInt32, lclid String) ENGINE=MergeTree ORDER BY household_key;
CREATE TABLE constellation.dim_date ON CLUSTER dwh_cluster (date_key UInt32, full_date Date, year UInt16, month UInt8, day UInt8, day_name String) ENGINE=MergeTree ORDER BY date_key;
CREATE TABLE constellation.dim_time ON CLUSTER dwh_cluster (time_key UInt16, hour UInt8, minute UInt8) ENGINE=MergeTree ORDER BY time_key;
CREATE TABLE constellation.dim_category ON CLUSTER dwh_cluster (category_key UInt8, category_name String) ENGINE=MergeTree ORDER BY category_key;
CREATE TABLE constellation.fact_consumption_local ON CLUSTER dwh_cluster (date_key UInt32, time_key UInt16, household_key UInt32, category_key UInt8, kwh Float32) ENGINE=MergeTree ORDER BY (household_key, date_key, time_key);
CREATE TABLE constellation.fact_consumption ON CLUSTER dwh_cluster AS constellation.fact_consumption_local ENGINE=Distributed(dwh_cluster, constellation, fact_consumption_local, cityHash64(household_key));
CREATE TABLE constellation.fact_daily_usage_local ON CLUSTER dwh_cluster (date_key UInt32, household_key UInt32, total_kwh Float32, avg_kwh Float32, max_kwh Float32, readings UInt16) ENGINE=MergeTree ORDER BY (household_key, date_key);
CREATE TABLE constellation.fact_daily_usage ON CLUSTER dwh_cluster AS constellation.fact_daily_usage_local ENGINE=Distributed(dwh_cluster, constellation, fact_daily_usage_local, cityHash64(household_key));