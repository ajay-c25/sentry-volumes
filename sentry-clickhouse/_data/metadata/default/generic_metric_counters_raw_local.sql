ATTACH TABLE generic_metric_counters_raw_local
(
    `use_case_id` LowCardinality(String), 
    `org_id` UInt64, 
    `project_id` UInt64, 
    `metric_id` UInt64, 
    `timestamp` DateTime, 
    `retention_days` UInt16, 
    `tags.key` Array(UInt64), 
    `tags.indexed_value` Array(UInt64), 
    `tags.raw_value` Array(String), 
    `set_values` Array(UInt64), 
    `count_value` Float64, 
    `distribution_values` Array(Float64), 
    `metric_type` LowCardinality(String), 
    `materialization_version` UInt8, 
    `timeseries_id` UInt32, 
    `partition` UInt16, 
    `offset` UInt64, 
    `granularities` Array(UInt8)
)
ENGINE = MergeTree()
PARTITION BY toStartOfInterval(timestamp, toIntervalDay(3))
ORDER BY (use_case_id, org_id, project_id, metric_id, timestamp)
TTL timestamp + toIntervalDay(7)
SETTINGS index_granularity = 8192
