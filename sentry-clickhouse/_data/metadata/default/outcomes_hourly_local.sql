ATTACH TABLE outcomes_hourly_local
(
    `org_id` UInt64, 
    `project_id` UInt64, 
    `key_id` UInt64, 
    `timestamp` DateTime, 
    `category` UInt8, 
    `outcome` UInt8, 
    `reason` LowCardinality(String), 
    `quantity` UInt64, 
    `times_seen` UInt64, 
    `bytes_received` UInt64
)
ENGINE = SummingMergeTree()
PARTITION BY toMonday(timestamp)
PRIMARY KEY (org_id, project_id, key_id, outcome, reason, timestamp)
ORDER BY (org_id, project_id, key_id, outcome, reason, timestamp, category)
TTL timestamp + toIntervalDay(90)
SETTINGS index_granularity = 256
