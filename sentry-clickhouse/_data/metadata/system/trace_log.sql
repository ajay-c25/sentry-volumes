ATTACH TABLE trace_log
(
    `event_date` Date, 
    `event_time` DateTime, 
    `revision` UInt32, 
    `trace_type` Enum8('Real' = 0, 'CPU' = 1, 'Memory' = 2), 
    `thread_id` UInt64, 
    `query_id` String, 
    `trace` Array(UInt64), 
    `size` UInt64
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(event_date)
ORDER BY (event_date, event_time)
SETTINGS index_granularity = 1024
