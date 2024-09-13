ATTACH TABLE outcomes_raw_local
(
    `org_id` UInt64, 
    `project_id` UInt64, 
    `key_id` Nullable(UInt64), 
    `timestamp` DateTime, 
    `category` UInt8, 
    `outcome` UInt8, 
    `reason` LowCardinality(Nullable(String)), 
    `quantity` UInt32, 
    `event_id` Nullable(UUID) CODEC(LZ4HC(0)) TTL timestamp + toIntervalDay(30), 
    `size` UInt32, 
    INDEX minmax_key_id key_id TYPE minmax GRANULARITY 1, 
    INDEX minmax_outcome outcome TYPE minmax GRANULARITY 1
)
ENGINE = MergeTree()
PARTITION BY toMonday(timestamp)
ORDER BY (org_id, project_id, timestamp)
TTL timestamp + toIntervalDay(30)
SETTINGS index_granularity = 16384
