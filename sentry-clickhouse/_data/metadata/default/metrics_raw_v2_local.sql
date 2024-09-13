ATTACH TABLE metrics_raw_v2_local
(
    `use_case_id` LowCardinality(String), 
    `org_id` UInt64, 
    `project_id` UInt64, 
    `metric_id` UInt64, 
    `timestamp` DateTime, 
    `tags.key` Array(UInt64), 
    `tags.value` Array(UInt64), 
    `metric_type` LowCardinality(String), 
    `set_values` Array(UInt64), 
    `count_value` Float64, 
    `distribution_values` Array(Float64), 
    `materialization_version` UInt8, 
    `retention_days` UInt16, 
    `partition` UInt16, 
    `offset` UInt64, 
    `timeseries_id` UInt32
)
ENGINE = MergeTree()
PARTITION BY toStartOfInterval(timestamp, toIntervalDay(3))
ORDER BY (use_case_id, metric_type, org_id, project_id, metric_id, timestamp)
TTL timestamp + toIntervalDay(7)
SETTINGS index_granularity = 8192
