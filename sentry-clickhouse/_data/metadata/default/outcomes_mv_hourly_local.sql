ATTACH MATERIALIZED VIEW outcomes_mv_hourly_local TO default.outcomes_hourly_local
(
    `org_id` UInt64, 
    `project_id` UInt64, 
    `key_id` UInt64, 
    `timestamp` DateTime, 
    `outcome` UInt8, 
    `reason` String, 
    `category` UInt8, 
    `quantity` UInt64, 
    `times_seen` UInt64
) AS
SELECT 
    org_id, 
    project_id, 
    ifNull(key_id, 0) AS key_id, 
    toStartOfHour(timestamp) AS timestamp, 
    outcome, 
    ifNull(reason, 'none') AS reason, 
    category, 
    count() AS times_seen, 
    sum(quantity) AS quantity
FROM default.outcomes_raw_local
GROUP BY 
    org_id, 
    project_id, 
    key_id, 
    timestamp, 
    outcome, 
    reason, 
    category
