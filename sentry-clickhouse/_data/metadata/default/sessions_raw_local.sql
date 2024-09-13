ATTACH TABLE sessions_raw_local
(
    `session_id` UUID, 
    `distinct_id` UUID, 
    `quantity` UInt32 DEFAULT 1, 
    `seq` UInt64, 
    `org_id` UInt64, 
    `project_id` UInt64, 
    `retention_days` UInt16, 
    `duration` UInt32, 
    `status` UInt8, 
    `errors` UInt16, 
    `received` DateTime, 
    `started` DateTime, 
    `release` LowCardinality(String), 
    `environment` LowCardinality(String), 
    `user_agent` LowCardinality(String), 
    `os` LowCardinality(String)
)
ENGINE = MergeTree()
PARTITION BY toMonday(started)
ORDER BY (org_id, project_id, release, environment, started)
TTL started + toIntervalDay(30)
SETTINGS index_granularity = 16384
