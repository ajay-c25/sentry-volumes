ATTACH MATERIALIZED VIEW generic_metric_counters_aggregation_mv TO default.generic_metric_counters_aggregated_local
(
    `org_id` UInt64, 
    `project_id` UInt64, 
    `metric_id` UInt64, 
    `granularity` UInt8, 
    `timestamp` DateTime CODEC(DoubleDelta), 
    `retention_days` UInt16, 
    `tags.key` Array(UInt64), 
    `tags.indexed_value` Array(UInt64), 
    `tags.raw_value` Array(String), 
    `value` AggregateFunction(sum, Float64), 
    `use_case_id` LowCardinality(String)
) AS
SELECT 
    use_case_id, 
    org_id, 
    project_id, 
    metric_id, 
    arrayJoin(granularities) AS granularity, 
    tags.key, 
    tags.indexed_value, 
    tags.raw_value, 
    toDateTime(multiIf(granularity = 0, 10, granularity = 1, 60, granularity = 2, 3600, granularity = 3, 86400, -1) * intDiv(toUnixTimestamp(timestamp), multiIf(granularity = 0, 10, granularity = 1, 60, granularity = 2, 3600, granularity = 3, 86400, -1))) AS timestamp, 
    retention_days, 
    sumState(count_value) AS value
FROM default.generic_metric_counters_raw_local
WHERE (materialization_version = 1) AND (metric_type = 'counter')
GROUP BY 
    use_case_id, 
    org_id, 
    project_id, 
    metric_id, 
    tags.key, 
    tags.indexed_value, 
    tags.raw_value, 
    timestamp, 
    granularity, 
    retention_days
