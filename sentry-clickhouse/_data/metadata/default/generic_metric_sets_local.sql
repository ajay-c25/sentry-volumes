ATTACH TABLE generic_metric_sets_local
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
    `value` AggregateFunction(uniqCombined64, UInt64), 
    `use_case_id` LowCardinality(String), 
    `_indexed_tags_hash` Array(UInt64) MATERIALIZED arrayMap((k, v) -> cityHash64(concat(toString(k), '=', toString(v))), tags.key, tags.indexed_value), 
    `_raw_tags_hash` Array(UInt64) MATERIALIZED arrayMap((k, v) -> cityHash64(concat(toString(k), '=', v)), tags.key, tags.raw_value), 
    INDEX bf_indexed_tags_hash _indexed_tags_hash TYPE bloom_filter() GRANULARITY 1, 
    INDEX bf_raw_tags_hash _raw_tags_hash TYPE bloom_filter() GRANULARITY 1, 
    INDEX bf_tags_key_hash tags.key TYPE bloom_filter() GRANULARITY 1
)
ENGINE = AggregatingMergeTree()
PARTITION BY (retention_days, toMonday(timestamp))
PRIMARY KEY (org_id, project_id, metric_id, granularity, timestamp)
ORDER BY (org_id, project_id, metric_id, granularity, timestamp, tags.key, tags.indexed_value, tags.raw_value, retention_days, use_case_id)
TTL timestamp + toIntervalDay(retention_days)
SETTINGS index_granularity = 2048
