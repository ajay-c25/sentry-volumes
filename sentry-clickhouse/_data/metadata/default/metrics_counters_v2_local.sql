ATTACH TABLE metrics_counters_v2_local
(
    `use_case_id` LowCardinality(String), 
    `org_id` UInt64, 
    `project_id` UInt64, 
    `metric_id` UInt64, 
    `granularity` UInt32, 
    `tags.key` Array(UInt64), 
    `tags.value` Array(UInt64), 
    `_tags_hash` Array(UInt64) MATERIALIZED arrayMap((k, v) -> cityHash64(concat(toString(k), '=', toString(v))), tags.key, tags.value), 
    `timestamp` DateTime, 
    `retention_days` UInt16, 
    `value` AggregateFunction(sum, Float64), 
    INDEX bf_tags_hash _tags_hash TYPE bloom_filter() GRANULARITY 1, 
    INDEX bf_tags_key_hash tags.key TYPE bloom_filter() GRANULARITY 1
)
ENGINE = AggregatingMergeTree()
PARTITION BY (retention_days, toMonday(timestamp))
PRIMARY KEY (use_case_id, org_id, project_id, metric_id, granularity, timestamp)
ORDER BY (use_case_id, org_id, project_id, metric_id, granularity, timestamp, tags.key, tags.value, retention_days)
TTL timestamp + toIntervalDay(retention_days)
SETTINGS index_granularity = 2048
