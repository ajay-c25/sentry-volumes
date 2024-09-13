ATTACH TABLE sessions_hourly_local
(
    `org_id` UInt64, 
    `project_id` UInt64, 
    `started` DateTime, 
    `release` LowCardinality(String), 
    `environment` LowCardinality(String), 
    `user_agent` LowCardinality(String), 
    `os` LowCardinality(String), 
    `duration_quantiles` AggregateFunction(quantilesIf(0.5, 0.9), UInt32, UInt8), 
    `duration_avg` AggregateFunction(avgIf, UInt32, UInt8), 
    `sessions` AggregateFunction(countIf, UUID, UInt8), 
    `sessions_preaggr` AggregateFunction(sumIf, UInt32, UInt8), 
    `users` AggregateFunction(uniqIf, UUID, UInt8), 
    `sessions_crashed` AggregateFunction(countIf, UUID, UInt8), 
    `sessions_crashed_preaggr` AggregateFunction(sumIf, UInt32, UInt8), 
    `sessions_abnormal` AggregateFunction(countIf, UUID, UInt8), 
    `sessions_abnormal_preaggr` AggregateFunction(sumIf, UInt32, UInt8), 
    `sessions_errored` AggregateFunction(uniqIf, UUID, UInt8), 
    `sessions_errored_preaggr` AggregateFunction(sumIf, UInt32, UInt8), 
    `users_crashed` AggregateFunction(uniqIf, UUID, UInt8), 
    `users_abnormal` AggregateFunction(uniqIf, UUID, UInt8), 
    `users_errored` AggregateFunction(uniqIf, UUID, UInt8)
)
ENGINE = AggregatingMergeTree()
PARTITION BY toMonday(started)
ORDER BY (org_id, project_id, release, environment, started)
TTL started + toIntervalDay(90)
SETTINGS index_granularity = 256
