ATTACH TABLE groupassignee_local
(
    `offset` UInt64, 
    `record_deleted` UInt8, 
    `project_id` UInt64, 
    `group_id` UInt64, 
    `date_added` Nullable(DateTime), 
    `user_id` Nullable(UInt64), 
    `team_id` Nullable(UInt64)
)
ENGINE = ReplacingMergeTree(offset)
ORDER BY (project_id, group_id)
SETTINGS index_granularity = 8192
