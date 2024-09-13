ATTACH MATERIALIZED VIEW metrics_counters_polymorphic_mv_v4_local TO default.metrics_counters_v2_local
(
    `use_case_id` LowCardinality(String), 
    `org_id` UInt64, 
    `project_id` UInt64, 
    `metric_id` UInt64, 
    `granularity` UInt32, 
    `tags.key` Array(UInt64), 
    `tags.value` Array(UInt64), 
    `timestamp` DateTime, 
    `retention_days` UInt16, 
    `value` AggregateFunction(sum, Float64)
) AS
SELECT 
    use_case_id, 
    org_id, 
    project_id, 
    metric_id, 
    arrayJoin([10, 60, 3600, 86400]) AS granularity, 
    tags.key, 
    tags.value, 
    toDateTime(granularity * intDiv(toUnixTimestamp(timestamp), granularity)) AS timestamp, 
    retention_days, 
    sumState(count_value) AS value
FROM default.metrics_raw_v2_local
WHERE (materialization_version = 4) AND (metric_type = 'counter') AND (1 = 1)
GROUP BY 
    use_case_id, 
    org_id, 
    project_id, 
    metric_id, 
    tags.key, 
    tags.value, 
    timestamp, 
    granularity, 
    retention_days
