-- STAR
INSERT INTO star.dim_household SELECT DISTINCT toUInt32(substring(lclid,4)), lclid FROM dwh.electricity;
INSERT INTO star.dim_date SELECT DISTINCT toYYYYMMDD(ts), toDate(ts), toYear(ts), toMonth(ts), toDayOfMonth(ts), dateName('weekday', ts) FROM dwh.electricity;
INSERT INTO star.dim_time SELECT DISTINCT toHour(ts)*60+toMinute(ts), toHour(ts), toMinute(ts) FROM dwh.electricity;
INSERT INTO star.dim_category VALUES (1,'Low'),(2,'Medium'),(3,'High');

-- CONSTELLATION
INSERT INTO constellation.dim_household SELECT DISTINCT toUInt32(substring(lclid,4)), lclid FROM dwh.electricity;
INSERT INTO constellation.dim_date SELECT DISTINCT toYYYYMMDD(ts), toDate(ts), toYear(ts), toMonth(ts), toDayOfMonth(ts), dateName('weekday', ts) FROM dwh.electricity;
INSERT INTO constellation.dim_time SELECT DISTINCT toHour(ts)*60+toMinute(ts), toHour(ts), toMinute(ts) FROM dwh.electricity;
INSERT INTO constellation.dim_category VALUES (1,'Low'),(2,'Medium'),(3,'High');

-- SNOWFLAKE
INSERT INTO snowflake.dim_household SELECT DISTINCT toUInt32(substring(lclid,4)), lclid FROM dwh.electricity;
INSERT INTO snowflake.dim_category VALUES (1,'Low'),(2,'Medium'),(3,'High');
INSERT INTO snowflake.dim_year SELECT DISTINCT toYear(ts), toYear(ts) FROM dwh.electricity;
INSERT INTO snowflake.dim_month SELECT DISTINCT toYYYYMM(ts), toMonth(ts), monthName(ts), toYear(ts) FROM dwh.electricity;
INSERT INTO snowflake.dim_day_name SELECT DISTINCT toDayOfWeek(ts), dateName('weekday', ts) FROM dwh.electricity;
INSERT INTO snowflake.dim_date SELECT DISTINCT toYYYYMMDD(ts), toDate(ts), toDayOfMonth(ts), toYYYYMM(ts), toDayOfWeek(ts) FROM dwh.electricity;
INSERT INTO snowflake.dim_day_part VALUES (1,'Night'),(2,'Morning'),(3,'Afternoon'),(4,'Evening');
INSERT INTO snowflake.dim_hour SELECT DISTINCT toHour(ts), toHour(ts), multiIf(toHour(ts)<6,1,toHour(ts)<12,2,toHour(ts)<18,3,4) FROM dwh.electricity;
INSERT INTO snowflake.dim_time SELECT DISTINCT toHour(ts)*60+toMinute(ts), toMinute(ts), toHour(ts) FROM dwh.electricity;