ATTACH TABLE migrations_local
(
    `group` String, 
    `migration_id` String, 
    `timestamp` DateTime, 
    `status` Enum8('completed' = 0, 'in_progress' = 1, 'not_started' = 2), 
    `version` UInt64 DEFAULT 1
)
ENGINE = ReplacingMergeTree(version)
ORDER BY (group, migration_id)
SETTINGS index_granularity = 8192
