ATTACH TABLE groupedmessage_local
(
    `offset` UInt64, 
    `record_deleted` UInt8, 
    `project_id` UInt64, 
    `id` UInt64, 
    `status` Nullable(UInt8), 
    `last_seen` Nullable(DateTime), 
    `first_seen` Nullable(DateTime), 
    `active_at` Nullable(DateTime), 
    `first_release_id` Nullable(UInt64)
)
ENGINE = ReplacingMergeTree(offset)
ORDER BY (project_id, id)
SAMPLE BY id
SETTINGS index_granularity = 8192
