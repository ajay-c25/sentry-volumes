ATTACH MATERIALIZED VIEW metrics_distributions_polymorphic_mv_v4_local TO default.metrics_distributions_v2_local
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
    `percentiles` AggregateFunction(quantiles(0.5, 0.75, 0.9, 0.95, 0.99), Float64), 
    `min` AggregateFunction(min, Float64), 
    `max` AggregateFunction(max, Float64), 
    `avg` AggregateFunction(avg, Float64), 
    `sum` AggregateFunction(sum, Float64), 
    `count` AggregateFunction(count, Float64), 
    `histogram` AggregateFunction(histogram(250), Float64)
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
    quantilesState(0.5, 0.75, 0.9, 0.95, 0.99)(arrayJoin(distribution_values) AS values_rows) AS percentiles, 
    minState(values_rows) AS min, 
    maxState(values_rows) AS max, 
    avgState(values_rows) AS avg, 
    sumState(values_rows) AS sum, 
    countState(values_rows) AS count, 
    histogramState(250)(values_rows) AS histogram_buckets
FROM default.metrics_raw_v2_local
WHERE (materialization_version = 4) AND (metric_type = 'distribution')
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
