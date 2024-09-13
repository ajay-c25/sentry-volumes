ATTACH TABLE generic_metric_distributions_aggregated_local
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
    `use_case_id` LowCardinality(String), 
    `percentiles` AggregateFunction(quantiles(0.5, 0.75, 0.9, 0.95, 0.99), Float64), 
    `min` AggregateFunction(min, Float64), 
    `max` AggregateFunction(max, Float64), 
    `avg` AggregateFunction(avg, Float64), 
    `sum` AggregateFunction(sum, Float64), 
    `count` AggregateFunction(count, Float64), 
    `histogram_buckets` AggregateFunction(histogram(250), Float64), 
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
