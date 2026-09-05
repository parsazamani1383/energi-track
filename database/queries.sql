-- EnergiTrack
-- Analytical SQL Queries
-- PostgreSQL
--
-- Purpose:
-- Analytical and reporting queries for the EnergiTrack database.
-- The queries are organized from basic operational reports to
-- energy cost, efficiency, maintenance, and advanced analysis.
--
-- ================================================================


-- ================================================================
-- 1. Total Production by Production Unit and Product
-- ================================================================

SELECT
    pu.name AS production_unit,
    p.name AS product,
    ROUND(SUM(pr.production_quantity), 2) AS total_production_ton
FROM production_record pr
JOIN production_unit pu
    ON pr.production_unit_id = pu.production_unit_id
JOIN product p
    ON pr.product_id = p.product_id
GROUP BY
    pu.production_unit_id,
    pu.name,
    p.product_id,
    p.name
ORDER BY total_production_ton DESC;


-- ================================================================
-- 2. Monthly Production by Production Unit
-- ================================================================

SELECT
    DATE_TRUNC('month', pr.timestamp)::date AS month,
    pu.name AS production_unit,
    ROUND(SUM(pr.production_quantity), 2) AS production_ton
FROM production_record pr
JOIN production_unit pu
    ON pr.production_unit_id = pu.production_unit_id
GROUP BY
    DATE_TRUNC('month', pr.timestamp),
    pu.production_unit_id,
    pu.name
ORDER BY
    month,
    pu.production_unit_id;


-- ================================================================
-- 3. Daily Production by Production Unit
-- ================================================================

SELECT
    pr.timestamp::date AS production_date,
    pu.name AS production_unit,
    ROUND(SUM(pr.production_quantity), 2) AS production_ton
FROM production_record pr
JOIN production_unit pu
    ON pr.production_unit_id = pu.production_unit_id
GROUP BY
    pr.timestamp::date,
    pu.production_unit_id,
    pu.name
ORDER BY
    production_date,
    pu.production_unit_id;


-- ================================================================
-- 4. Average Hourly Production by Hour of Day
-- ================================================================

SELECT
    EXTRACT(HOUR FROM pr.timestamp)::int AS hour_of_day,
    pu.name AS production_unit,
    ROUND(AVG(pr.production_quantity), 2) AS avg_hourly_production_ton
FROM production_record pr
JOIN production_unit pu
    ON pr.production_unit_id = pu.production_unit_id
GROUP BY
    EXTRACT(HOUR FROM pr.timestamp),
    pu.production_unit_id,
    pu.name
ORDER BY
    pu.production_unit_id,
    hour_of_day;


-- ================================================================
-- 5. Production vs Unit/Product Capacity
-- ================================================================

SELECT
    pu.name AS production_unit,
    p.name AS product,
    upp.capacity AS configured_capacity_ton,
    ROUND(AVG(pr.production_quantity), 2) AS avg_hourly_production_ton,
    ROUND(
        100.0 * AVG(pr.production_quantity) / NULLIF(upp.capacity, 0),
        2
    ) AS average_capacity_utilization_pct
FROM production_record pr
JOIN production_unit_product upp
    ON pr.production_unit_id = upp.production_unit_id
   AND pr.product_id = upp.product_id
JOIN production_unit pu
    ON upp.production_unit_id = pu.production_unit_id
JOIN product p
    ON upp.product_id = p.product_id
GROUP BY
    pu.name,
    p.name,
    upp.capacity
ORDER BY average_capacity_utilization_pct DESC;


-- ================================================================
-- 6. Total Energy Consumption by Energy Source
-- ================================================================

SELECT
    es.name AS energy_source,
    es.unit_of_measure,
    COUNT(ec.energy_consumption_id) AS record_count,
    ROUND(SUM(ec.consumption_amount), 2) AS total_consumption
FROM energy_consumption ec
JOIN energy_source es
    ON ec.energy_source_id = es.energy_source_id
GROUP BY
    es.energy_source_id,
    es.name,
    es.unit_of_measure
ORDER BY total_consumption DESC;


-- ================================================================
-- 7. Energy Consumption by Production Unit and Energy Source
-- ================================================================

SELECT
    pu.name AS production_unit,
    es.name AS energy_source,
    es.unit_of_measure,
    ROUND(SUM(ec.consumption_amount), 2) AS total_consumption
FROM energy_consumption ec
JOIN equipment e
    ON ec.equipment_id = e.equipment_id
JOIN production_unit pu
    ON e.production_unit_id = pu.production_unit_id
JOIN energy_source es
    ON ec.energy_source_id = es.energy_source_id
GROUP BY
    pu.production_unit_id,
    pu.name,
    es.energy_source_id,
    es.name,
    es.unit_of_measure
ORDER BY
    pu.production_unit_id,
    es.energy_source_id;


-- ================================================================
-- 8. Monthly Energy Consumption by Production Unit
-- ================================================================

SELECT
    DATE_TRUNC('month', ec.timestamp)::date AS month,
    pu.name AS production_unit,
    es.name AS energy_source,
    ROUND(SUM(ec.consumption_amount), 2) AS total_consumption
FROM energy_consumption ec
JOIN equipment e
    ON ec.equipment_id = e.equipment_id
JOIN production_unit pu
    ON e.production_unit_id = pu.production_unit_id
JOIN energy_source es
    ON ec.energy_source_id = es.energy_source_id
GROUP BY
    DATE_TRUNC('month', ec.timestamp),
    pu.production_unit_id,
    pu.name,
    es.energy_source_id,
    es.name
ORDER BY
    month,
    pu.production_unit_id,
    es.energy_source_id;


-- ================================================================
-- 9. Energy Consumption by Equipment
-- ================================================================

SELECT
    e.name AS equipment,
    pu.name AS production_unit,
    es.name AS energy_source,
    ROUND(SUM(ec.consumption_amount), 2) AS total_consumption
FROM energy_consumption ec
JOIN equipment e
    ON ec.equipment_id = e.equipment_id
JOIN production_unit pu
    ON e.production_unit_id = pu.production_unit_id
JOIN energy_source es
    ON ec.energy_source_id = es.energy_source_id
GROUP BY
    e.equipment_id,
    e.name,
    pu.production_unit_id,
    pu.name,
    es.energy_source_id,
    es.name
ORDER BY total_consumption DESC;


-- ================================================================
-- 10. Electricity Consumption vs Rated Power
-- ================================================================

SELECT
    e.name AS equipment,
    pu.name AS production_unit,
    e.rated_power,
    ROUND(SUM(ec.consumption_amount), 2) AS total_electricity_kwh,
    ROUND(
        SUM(ec.consumption_amount)
        / NULLIF(e.rated_power * COUNT(DISTINCT ec.timestamp), 0),
        4
    ) AS average_load_factor
FROM energy_consumption ec
JOIN equipment e
    ON ec.equipment_id = e.equipment_id
JOIN production_unit pu
    ON e.production_unit_id = pu.production_unit_id
JOIN energy_source es
    ON ec.energy_source_id = es.energy_source_id
WHERE es.code = 'ELEC'
GROUP BY
    e.equipment_id,
    e.name,
    pu.name,
    e.rated_power
ORDER BY average_load_factor DESC;


-- ================================================================
-- 11. Monthly Energy Cost
-- ================================================================

SELECT
    DATE_TRUNC('month', ec.timestamp)::date AS month,
    es.name AS energy_source,
    ROUND(SUM(ec.consumption_amount), 2) AS total_consumption,
    ROUND(
        SUM(ec.consumption_amount * et.price_per_unit),
        2
    ) AS total_energy_cost
FROM energy_consumption ec
JOIN energy_source es
    ON ec.energy_source_id = es.energy_source_id
JOIN energy_tariff et
    ON et.energy_source_id = ec.energy_source_id
   AND ec.timestamp::date BETWEEN et.start_date AND et.end_date
GROUP BY
    DATE_TRUNC('month', ec.timestamp),
    es.energy_source_id,
    es.name
ORDER BY
    month,
    es.energy_source_id;


-- ================================================================
-- 12. Energy Cost by Production Unit
-- ================================================================

SELECT
    pu.name AS production_unit,
    es.name AS energy_source,
    ROUND(SUM(ec.consumption_amount), 2) AS total_consumption,
    ROUND(
        SUM(ec.consumption_amount * et.price_per_unit),
        2
    ) AS total_energy_cost
FROM energy_consumption ec
JOIN equipment e
    ON ec.equipment_id = e.equipment_id
JOIN production_unit pu
    ON e.production_unit_id = pu.production_unit_id
JOIN energy_source es
    ON ec.energy_source_id = es.energy_source_id
JOIN energy_tariff et
    ON et.energy_source_id = ec.energy_source_id
   AND ec.timestamp::date BETWEEN et.start_date AND et.end_date
GROUP BY
    pu.production_unit_id,
    pu.name,
    es.energy_source_id,
    es.name
ORDER BY total_energy_cost DESC;


-- ================================================================
-- 13. Total Energy Cost by Energy Source
-- ================================================================

SELECT
    es.name AS energy_source,
    ROUND(SUM(ec.consumption_amount), 2) AS total_consumption,
    ROUND(
        SUM(ec.consumption_amount * et.price_per_unit),
        2
    ) AS total_energy_cost,
    ROUND(
        SUM(ec.consumption_amount * et.price_per_unit)
        / NULLIF(SUM(ec.consumption_amount), 0),
        4
    ) AS weighted_avg_price_per_unit
FROM energy_consumption ec
JOIN energy_source es
    ON ec.energy_source_id = es.energy_source_id
JOIN energy_tariff et
    ON et.energy_source_id = ec.energy_source_id
   AND ec.timestamp::date BETWEEN et.start_date AND et.end_date
GROUP BY
    es.energy_source_id,
    es.name
ORDER BY total_energy_cost DESC;


-- ================================================================
-- 14. Energy Intensity by Production Unit
-- ================================================================
-- Electricity and Natural Gas are reported separately because their
-- physical units are different.

WITH production AS (
    SELECT
        production_unit_id,
        SUM(production_quantity) AS production_ton
    FROM production_record
    GROUP BY production_unit_id
),
energy AS (
    SELECT
        e.production_unit_id,
        SUM(
            CASE
                WHEN es.code = 'ELEC'
                    THEN ec.consumption_amount
                ELSE 0
            END
        ) AS electricity_kwh,
        SUM(
            CASE
                WHEN es.code = 'GAS'
                    THEN ec.consumption_amount
                ELSE 0
            END
        ) AS natural_gas_m3
    FROM energy_consumption ec
    JOIN equipment e
        ON ec.equipment_id = e.equipment_id
    JOIN energy_source es
        ON ec.energy_source_id = es.energy_source_id
    GROUP BY e.production_unit_id
)
SELECT
    pu.name AS production_unit,
    ROUND(p.production_ton, 2) AS total_production_ton,
    ROUND(e.electricity_kwh, 2) AS electricity_kwh,
    ROUND(e.natural_gas_m3, 2) AS natural_gas_m3,
    ROUND(
        e.electricity_kwh / NULLIF(p.production_ton, 0),
        4
    ) AS electricity_kwh_per_ton,
    ROUND(
        e.natural_gas_m3 / NULLIF(p.production_ton, 0),
        4
    ) AS natural_gas_m3_per_ton
FROM production p
JOIN energy e
    ON p.production_unit_id = e.production_unit_id
JOIN production_unit pu
    ON p.production_unit_id = pu.production_unit_id
ORDER BY pu.production_unit_id;


-- ================================================================
-- 15. Monthly Energy Intensity
-- ================================================================

WITH monthly_production AS (
    SELECT
        production_unit_id,
        DATE_TRUNC('month', timestamp)::date AS month,
        SUM(production_quantity) AS production_ton
    FROM production_record
    GROUP BY
        production_unit_id,
        DATE_TRUNC('month', timestamp)
),
monthly_energy AS (
    SELECT
        e.production_unit_id,
        DATE_TRUNC('month', ec.timestamp)::date AS month,
        SUM(
            CASE
                WHEN es.code = 'ELEC'
                    THEN ec.consumption_amount
                ELSE 0
            END
        ) AS electricity_kwh,
        SUM(
            CASE
                WHEN es.code = 'GAS'
                    THEN ec.consumption_amount
                ELSE 0
            END
        ) AS natural_gas_m3
    FROM energy_consumption ec
    JOIN equipment e
        ON ec.equipment_id = e.equipment_id
    JOIN energy_source es
        ON ec.energy_source_id = es.energy_source_id
    GROUP BY
        e.production_unit_id,
        DATE_TRUNC('month', ec.timestamp)
)
SELECT
    pu.name AS production_unit,
    mp.month,
    ROUND(mp.production_ton, 2) AS production_ton,
    ROUND(me.electricity_kwh, 2) AS electricity_kwh,
    ROUND(me.natural_gas_m3, 2) AS natural_gas_m3,
    ROUND(
        me.electricity_kwh / NULLIF(mp.production_ton, 0),
        4
    ) AS electricity_kwh_per_ton,
    ROUND(
        me.natural_gas_m3 / NULLIF(mp.production_ton, 0),
        4
    ) AS natural_gas_m3_per_ton
FROM monthly_production mp
JOIN monthly_energy me
    ON mp.production_unit_id = me.production_unit_id
   AND mp.month = me.month
JOIN production_unit pu
    ON mp.production_unit_id = pu.production_unit_id
ORDER BY
    mp.month,
    pu.production_unit_id;


-- ================================================================
-- 16. Raw Material Consumption by Material
-- ================================================================

SELECT
    rm.name AS raw_material,
    rm.unit_of_measure,
    COUNT(mc.material_consumption_id) AS record_count,
    ROUND(SUM(mc.quantity), 2) AS total_consumption
FROM material_consumption mc
JOIN raw_material rm
    ON mc.raw_material_id = rm.raw_material_id
GROUP BY
    rm.raw_material_id,
    rm.name,
    rm.unit_of_measure
ORDER BY total_consumption DESC;


-- ================================================================
-- 17. Material Consumption per Ton of Production
-- ================================================================

WITH material_totals AS (
    SELECT
        pr.production_unit_id,
        pr.product_id,
        mc.raw_material_id,
        SUM(mc.quantity) AS material_quantity
    FROM material_consumption mc
    JOIN production_record pr
        ON mc.production_record_id = pr.production_record_id
    GROUP BY
        pr.production_unit_id,
        pr.product_id,
        mc.raw_material_id
),
production_totals AS (
    SELECT
        production_unit_id,
        product_id,
        SUM(production_quantity) AS production_quantity
    FROM production_record
    GROUP BY
        production_unit_id,
        product_id
)
SELECT
    pu.name AS production_unit,
    p.name AS product,
    rm.name AS raw_material,
    ROUND(mt.material_quantity, 2) AS total_material_consumption,
    ROUND(pt.production_quantity, 2) AS total_production_ton,
    ROUND(
        mt.material_quantity
        / NULLIF(pt.production_quantity, 0),
        4
    ) AS material_per_ton
FROM material_totals mt
JOIN production_totals pt
    ON mt.production_unit_id = pt.production_unit_id
   AND mt.product_id = pt.product_id
JOIN production_unit pu
    ON mt.production_unit_id = pu.production_unit_id
JOIN product p
    ON mt.product_id = p.product_id
JOIN raw_material rm
    ON mt.raw_material_id = rm.raw_material_id
ORDER BY
    pu.production_unit_id,
    p.product_id,
    rm.raw_material_id;


-- ================================================================
-- 18. Maintenance Summary by Equipment
-- ================================================================

SELECT
    e.name AS equipment,
    pu.name AS production_unit,
    COUNT(m.maintenance_id) AS maintenance_count,
    COUNT(*) FILTER (WHERE m.type = 'Preventive') AS preventive_count,
    COUNT(*) FILTER (WHERE m.type = 'Corrective') AS corrective_count,
    ROUND(COALESCE(SUM(m.cost), 0), 2) AS total_maintenance_cost,
    ROUND(
        COALESCE(
            SUM(EXTRACT(EPOCH FROM (m.end_time - m.start_time)) / 3600.0),
            0
        ),
        2
    ) AS total_maintenance_hours
FROM equipment e
JOIN production_unit pu
    ON e.production_unit_id = pu.production_unit_id
LEFT JOIN maintenance m
    ON e.equipment_id = m.equipment_id
GROUP BY
    e.equipment_id,
    e.name,
    pu.name
ORDER BY total_maintenance_cost DESC;


-- ================================================================
-- 19. Maintenance Cost by Production Unit
-- ================================================================

SELECT
    pu.name AS production_unit,
    COUNT(m.maintenance_id) AS maintenance_count,
    ROUND(COALESCE(SUM(m.cost), 0), 2) AS total_maintenance_cost,
    ROUND(
        COALESCE(
            SUM(EXTRACT(EPOCH FROM (m.end_time - m.start_time)) / 3600.0),
            0
        ),
        2
    ) AS maintenance_hours
FROM production_unit pu
LEFT JOIN equipment e
    ON e.production_unit_id = pu.production_unit_id
LEFT JOIN maintenance m
    ON m.equipment_id = e.equipment_id
GROUP BY
    pu.production_unit_id,
    pu.name
ORDER BY total_maintenance_cost DESC;


-- ================================================================
-- 20. Maintenance Type Comparison
-- ================================================================

SELECT
    m.type AS maintenance_type,
    COUNT(*) AS maintenance_count,
    ROUND(SUM(COALESCE(m.cost, 0)), 2) AS total_cost,
    ROUND(AVG(COALESCE(m.cost, 0)), 2) AS average_cost,
    ROUND(
        SUM(EXTRACT(EPOCH FROM (m.end_time - m.start_time)) / 3600.0),
        2
    ) AS total_hours
FROM maintenance m
GROUP BY m.type
ORDER BY total_cost DESC;


-- ================================================================
-- 21. Equipment with Highest Maintenance Cost
-- ================================================================

SELECT
    e.name AS equipment,
    pu.name AS production_unit,
    ROUND(SUM(COALESCE(m.cost, 0)), 2) AS total_maintenance_cost
FROM maintenance m
JOIN equipment e
    ON m.equipment_id = e.equipment_id
JOIN production_unit pu
    ON e.production_unit_id = pu.production_unit_id
GROUP BY
    e.equipment_id,
    e.name,
    pu.name
ORDER BY total_maintenance_cost DESC
LIMIT 10;


-- ================================================================
-- 22. Production During Maintenance vs Normal Periods
-- ================================================================

WITH production_condition AS (
    SELECT
        pr.production_record_id,
        pr.production_unit_id,
        pr.production_quantity,
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM maintenance m
                JOIN equipment e
                    ON m.equipment_id = e.equipment_id
                WHERE e.production_unit_id = pr.production_unit_id
                  AND e.type IN ('Furnace', 'Rolling Mill', 'Motor')
                  AND m.start_time <= pr.timestamp
                  AND m.end_time > pr.timestamp
            )
            THEN 'Maintenance'
            ELSE 'Normal'
        END AS operating_condition
    FROM production_record pr
)
SELECT
    pu.name AS production_unit,
    pc.operating_condition,
    COUNT(*) AS hourly_records,
    ROUND(AVG(pc.production_quantity), 2) AS avg_hourly_production,
    ROUND(SUM(pc.production_quantity), 2) AS total_production
FROM production_condition pc
JOIN production_unit pu
    ON pc.production_unit_id = pu.production_unit_id
GROUP BY
    pu.production_unit_id,
    pu.name,
    pc.operating_condition
ORDER BY
    pu.production_unit_id,
    pc.operating_condition;


-- ================================================================
-- 23. Zero-Production Hours
-- ================================================================

SELECT
    pu.name AS production_unit,
    COUNT(*) AS zero_production_hours
FROM production_record pr
JOIN production_unit pu
    ON pr.production_unit_id = pu.production_unit_id
WHERE pr.production_quantity = 0
GROUP BY
    pu.production_unit_id,
    pu.name
ORDER BY zero_production_hours DESC;


-- ================================================================
-- 24. Highest Energy-Consuming Equipment
-- ================================================================

WITH equipment_energy AS (
    SELECT
        e.equipment_id,
        e.name AS equipment,
        pu.name AS production_unit,
        SUM(
            CASE
                WHEN es.code = 'ELEC'
                    THEN ec.consumption_amount
                ELSE 0
            END
        ) AS electricity_kwh,
        SUM(
            CASE
                WHEN es.code = 'GAS'
                    THEN ec.consumption_amount
                ELSE 0
            END
        ) AS natural_gas_m3
    FROM energy_consumption ec
    JOIN equipment e
        ON ec.equipment_id = e.equipment_id
    JOIN production_unit pu
        ON e.production_unit_id = pu.production_unit_id
    JOIN energy_source es
        ON ec.energy_source_id = es.energy_source_id
    GROUP BY
        e.equipment_id,
        e.name,
        pu.name
)
SELECT
    equipment,
    production_unit,
    ROUND(electricity_kwh, 2) AS electricity_kwh,
    ROUND(natural_gas_m3, 2) AS natural_gas_m3
FROM equipment_energy
ORDER BY electricity_kwh DESC
LIMIT 10;


-- ================================================================
-- 25. Monthly Energy Cost Ranking by Production Unit
-- ================================================================

WITH monthly_cost AS (
    SELECT
        pu.production_unit_id,
        pu.name AS production_unit,
        DATE_TRUNC('month', ec.timestamp)::date AS month,
        SUM(ec.consumption_amount * et.price_per_unit) AS energy_cost
    FROM energy_consumption ec
    JOIN equipment e
        ON ec.equipment_id = e.equipment_id
    JOIN production_unit pu
        ON e.production_unit_id = pu.production_unit_id
    JOIN energy_tariff et
        ON et.energy_source_id = ec.energy_source_id
       AND ec.timestamp::date BETWEEN et.start_date AND et.end_date
    GROUP BY
        pu.production_unit_id,
        pu.name,
        DATE_TRUNC('month', ec.timestamp)
)
SELECT
    month,
    production_unit,
    ROUND(energy_cost, 2) AS energy_cost,
    DENSE_RANK() OVER (
        PARTITION BY month
        ORDER BY energy_cost DESC
    ) AS cost_rank
FROM monthly_cost
ORDER BY
    month,
    cost_rank;


-- ================================================================
-- 26. Month-over-Month Production Change
-- ================================================================

WITH monthly_production AS (
    SELECT
        production_unit_id,
        DATE_TRUNC('month', timestamp)::date AS month,
        SUM(production_quantity) AS production_ton
    FROM production_record
    GROUP BY
        production_unit_id,
        DATE_TRUNC('month', timestamp)
),
with_previous AS (
    SELECT
        production_unit_id,
        month,
        production_ton,
        LAG(production_ton) OVER (
            PARTITION BY production_unit_id
            ORDER BY month
        ) AS previous_month_production
    FROM monthly_production
)
SELECT
    pu.name AS production_unit,
    month,
    ROUND(production_ton, 2) AS production_ton,
    ROUND(previous_month_production, 2) AS previous_month_production,
    ROUND(
        100.0
        * (production_ton - previous_month_production)
        / NULLIF(previous_month_production, 0),
        2
    ) AS month_over_month_change_pct
FROM with_previous wp
JOIN production_unit pu
    ON wp.production_unit_id = pu.production_unit_id
ORDER BY
    pu.production_unit_id,
    month;


-- ================================================================
-- 27. Month-over-Month Energy Consumption Change
-- ================================================================

WITH monthly_energy AS (
    SELECT
        e.production_unit_id,
        ec.energy_source_id,
        DATE_TRUNC('month', ec.timestamp)::date AS month,
        SUM(ec.consumption_amount) AS consumption_amount
    FROM energy_consumption ec
    JOIN equipment e
        ON ec.equipment_id = e.equipment_id
    GROUP BY
        e.production_unit_id,
        ec.energy_source_id,
        DATE_TRUNC('month', ec.timestamp)
),
with_previous AS (
    SELECT
        production_unit_id,
        energy_source_id,
        month,
        consumption_amount,
        LAG(consumption_amount) OVER (
            PARTITION BY production_unit_id, energy_source_id
            ORDER BY month
        ) AS previous_month_consumption
    FROM monthly_energy
)
SELECT
    pu.name AS production_unit,
    es.name AS energy_source,
    month,
    ROUND(consumption_amount, 2) AS consumption,
    ROUND(previous_month_consumption, 2) AS previous_month_consumption,
    ROUND(
        100.0
        * (consumption_amount - previous_month_consumption)
        / NULLIF(previous_month_consumption, 0),
        2
    ) AS month_over_month_change_pct
FROM with_previous wp
JOIN production_unit pu
    ON wp.production_unit_id = pu.production_unit_id
JOIN energy_source es
    ON wp.energy_source_id = es.energy_source_id
ORDER BY
    pu.production_unit_id,
    es.energy_source_id,
    month;


-- ================================================================
-- 28. Top 10 Highest Electricity-Intensity Months
-- ================================================================

WITH monthly_production AS (
    SELECT
        production_unit_id,
        DATE_TRUNC('month', timestamp)::date AS month,
        SUM(production_quantity) AS production_ton
    FROM production_record
    GROUP BY
        production_unit_id,
        DATE_TRUNC('month', timestamp)
),
monthly_electricity AS (
    SELECT
        e.production_unit_id,
        DATE_TRUNC('month', ec.timestamp)::date AS month,
        SUM(ec.consumption_amount) AS electricity_kwh
    FROM energy_consumption ec
    JOIN equipment e
        ON ec.equipment_id = e.equipment_id
    JOIN energy_source es
        ON ec.energy_source_id = es.energy_source_id
    WHERE es.code = 'ELEC'
    GROUP BY
        e.production_unit_id,
        DATE_TRUNC('month', ec.timestamp)
)
SELECT
    pu.name AS production_unit,
    mp.month,
    ROUND(mp.production_ton, 2) AS production_ton,
    ROUND(me.electricity_kwh, 2) AS electricity_kwh,
    ROUND(
        me.electricity_kwh / NULLIF(mp.production_ton, 0),
        4
    ) AS electricity_kwh_per_ton
FROM monthly_production mp
JOIN monthly_electricity me
    ON mp.production_unit_id = me.production_unit_id
   AND mp.month = me.month
JOIN production_unit pu
    ON mp.production_unit_id = pu.production_unit_id
WHERE mp.production_ton > 0
ORDER BY electricity_kwh_per_ton DESC
LIMIT 10;


-- ================================================================
-- 29. Energy Source Cost Contribution by Production Unit
-- ================================================================

WITH unit_source_cost AS (
    SELECT
        pu.production_unit_id,
        pu.name AS production_unit,
        es.energy_source_id,
        es.name AS energy_source,
        SUM(ec.consumption_amount * et.price_per_unit) AS energy_cost
    FROM energy_consumption ec
    JOIN equipment e
        ON ec.equipment_id = e.equipment_id
    JOIN production_unit pu
        ON e.production_unit_id = pu.production_unit_id
    JOIN energy_source es
        ON ec.energy_source_id = es.energy_source_id
    JOIN energy_tariff et
        ON et.energy_source_id = ec.energy_source_id
       AND ec.timestamp::date BETWEEN et.start_date AND et.end_date
    GROUP BY
        pu.production_unit_id,
        pu.name,
        es.energy_source_id,
        es.name
),
unit_total_cost AS (
    SELECT
        production_unit_id,
        SUM(energy_cost) AS total_cost
    FROM unit_source_cost
    GROUP BY production_unit_id
)
SELECT
    usc.production_unit,
    usc.energy_source,
    ROUND(usc.energy_cost, 2) AS energy_cost,
    ROUND(
        100.0 * usc.energy_cost / NULLIF(utc.total_cost, 0),
        2
    ) AS cost_share_pct
FROM unit_source_cost usc
JOIN unit_total_cost utc
    ON usc.production_unit_id = utc.production_unit_id
ORDER BY
    usc.production_unit_id,
    cost_share_pct DESC;


-- ================================================================
-- 30. Overall Plant KPI Summary
-- ================================================================

WITH production AS (
    SELECT
        SUM(production_quantity) AS total_production_ton
    FROM production_record
),
energy AS (
    SELECT
        SUM(
            CASE
                WHEN es.code = 'ELEC'
                    THEN ec.consumption_amount
                ELSE 0
            END
        ) AS electricity_kwh,
        SUM(
            CASE
                WHEN es.code = 'GAS'
                    THEN ec.consumption_amount
                ELSE 0
            END
        ) AS natural_gas_m3,
        SUM(ec.consumption_amount * et.price_per_unit) AS total_energy_cost
    FROM energy_consumption ec
    JOIN energy_source es
        ON ec.energy_source_id = es.energy_source_id
    JOIN energy_tariff et
        ON et.energy_source_id = ec.energy_source_id
       AND ec.timestamp::date BETWEEN et.start_date AND et.end_date
),
maintenance_kpi AS (
    SELECT
        COUNT(*) AS maintenance_events,
        SUM(COALESCE(cost, 0)) AS maintenance_cost,
        SUM(
            EXTRACT(EPOCH FROM (end_time - start_time)) / 3600.0
        ) AS maintenance_hours
    FROM maintenance
)
SELECT
    ROUND(p.total_production_ton, 2) AS total_production_ton,
    ROUND(e.electricity_kwh, 2) AS electricity_kwh,
    ROUND(e.natural_gas_m3, 2) AS natural_gas_m3,
    ROUND(
        e.electricity_kwh / NULLIF(p.total_production_ton, 0),
        4
    ) AS electricity_kwh_per_ton,
    ROUND(
        e.natural_gas_m3 / NULLIF(p.total_production_ton, 0),
        4
    ) AS natural_gas_m3_per_ton,
    ROUND(e.total_energy_cost, 2) AS total_energy_cost,
    maintenance_kpi.maintenance_events,
    ROUND(maintenance_kpi.maintenance_cost, 2) AS maintenance_cost,
    ROUND(maintenance_kpi.maintenance_hours, 2) AS maintenance_hours
FROM production p
CROSS JOIN energy e
CROSS JOIN maintenance_kpi;


-- ================================================================
-- 31. Production Unit Performance Ranking
-- ================================================================

WITH unit_kpi AS (
    SELECT
        pu.production_unit_id,
        pu.name AS production_unit,
        SUM(pr.production_quantity) AS production_ton,
        AVG(
            pr.production_quantity
            / NULLIF(upp.capacity, 0)
        ) AS utilization_ratio
    FROM production_record pr
    JOIN production_unit pu
        ON pr.production_unit_id = pu.production_unit_id
    JOIN production_unit_product upp
        ON pr.production_unit_id = upp.production_unit_id
       AND pr.product_id = upp.product_id
    GROUP BY
        pu.production_unit_id,
        pu.name
)
SELECT
    production_unit,
    ROUND(production_ton, 2) AS total_production_ton,
    ROUND(100.0 * utilization_ratio, 2) AS avg_utilization_pct,
    RANK() OVER (
        ORDER BY production_ton DESC
    ) AS production_rank
FROM unit_kpi
ORDER BY production_rank;


-- ================================================================
-- End of EnergiTrack Analytical Queries
-- ================================================================
