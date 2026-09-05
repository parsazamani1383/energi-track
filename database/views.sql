-- EnergiTrack
-- Analytical Views
-- PostgreSQL

-- ================================================================
-- 1. Energy Consumption Summary by Equipment
-- ================================================================

CREATE OR REPLACE VIEW vw_equipment_energy_summary AS
SELECT
    e.equipment_id,
    e.code AS equipment_code,
    e.name AS equipment_name,
    pu.production_unit_id,
    pu.name AS production_unit,
    es.energy_source_id,
    es.code AS energy_source_code,
    es.name AS energy_source,
    es.unit_of_measure,
    COUNT(ec.energy_consumption_id) AS record_count,
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
    e.code,
    e.name,
    pu.production_unit_id,
    pu.name,
    es.energy_source_id,
    es.code,
    es.name,
    es.unit_of_measure;


-- ================================================================
-- 2. Energy Consumption Summary by Production Unit
-- ================================================================

CREATE OR REPLACE VIEW vw_production_unit_energy_summary AS
SELECT
    pu.production_unit_id,
    pu.code AS production_unit_code,
    pu.name AS production_unit,
    es.energy_source_id,
    es.code AS energy_source_code,
    es.name AS energy_source,
    es.unit_of_measure,
    COUNT(ec.energy_consumption_id) AS record_count,
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
    pu.code,
    pu.name,
    es.energy_source_id,
    es.code,
    es.name,
    es.unit_of_measure;


-- ================================================================
-- 3. Monthly Production
-- ================================================================

CREATE OR REPLACE VIEW vw_monthly_production AS
SELECT
    DATE_TRUNC('month', pr.timestamp)::date AS month,
    pu.production_unit_id,
    pu.code AS production_unit_code,
    pu.name AS production_unit,
    p.product_id,
    p.code AS product_code,
    p.name AS product,
    ROUND(SUM(pr.production_quantity), 2) AS production_ton,
    ROUND(SUM(pr.scrap_quantity), 2) AS scrap_ton,
    ROUND(
        100.0 * SUM(pr.scrap_quantity)
        / NULLIF(SUM(pr.production_quantity), 0),
        2
    ) AS scrap_rate_pct
FROM production_record pr
JOIN production_unit pu
    ON pr.production_unit_id = pu.production_unit_id
JOIN product p
    ON pr.product_id = p.product_id
GROUP BY
    DATE_TRUNC('month', pr.timestamp),
    pu.production_unit_id,
    pu.code,
    pu.name,
    p.product_id,
    p.code,
    p.name;


-- ================================================================
-- 4. Monthly Energy Intensity by Production Unit
-- ================================================================
-- Electricity and natural gas are calculated separately
-- because their physical units are different.

CREATE OR REPLACE VIEW vw_monthly_energy_intensity AS
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
    pu.production_unit_id,
    pu.code AS production_unit_code,
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
    ON mp.production_unit_id = pu.production_unit_id;


-- ================================================================
-- 5. Production Unit KPI Summary
-- ================================================================

CREATE OR REPLACE VIEW vw_production_unit_kpi AS
WITH production AS (
    SELECT
        production_unit_id,
        SUM(production_quantity) AS production_ton,
        SUM(scrap_quantity) AS scrap_ton,
        COUNT(*) AS production_records
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
        ) AS natural_gas_m3,

        SUM(
            ec.consumption_amount * et.price_per_unit
        ) AS energy_cost

    FROM energy_consumption ec
    JOIN equipment e
        ON ec.equipment_id = e.equipment_id
    JOIN energy_source es
        ON ec.energy_source_id = es.energy_source_id
    JOIN energy_tariff et
        ON et.energy_source_id = ec.energy_source_id
       AND ec.timestamp::date BETWEEN et.start_date AND et.end_date
    GROUP BY
        e.production_unit_id
),
maintenance_summary AS (
    SELECT
        e.production_unit_id,
        COUNT(m.maintenance_id) AS maintenance_events,
        SUM(COALESCE(m.cost, 0)) AS maintenance_cost,
        SUM(
            EXTRACT(
                EPOCH FROM (m.end_time - m.start_time)
            ) / 3600.0
        ) AS maintenance_hours
    FROM equipment e
    LEFT JOIN maintenance m
        ON m.equipment_id = e.equipment_id
    GROUP BY
        e.production_unit_id
)
SELECT
    pu.production_unit_id,
    pu.code AS production_unit_code,
    pu.name AS production_unit,

    ROUND(COALESCE(p.production_ton, 0), 2) AS production_ton,
    ROUND(COALESCE(p.scrap_ton, 0), 2) AS scrap_ton,
    COALESCE(p.production_records, 0) AS production_records,

    ROUND(
        100.0 * COALESCE(p.scrap_ton, 0)
        / NULLIF(COALESCE(p.production_ton, 0), 0),
        2
    ) AS scrap_rate_pct,

    ROUND(
        COALESCE(e.electricity_kwh, 0),
        2
    ) AS electricity_kwh,

    ROUND(
        COALESCE(e.natural_gas_m3, 0),
        2
    ) AS natural_gas_m3,

    ROUND(
        COALESCE(e.electricity_kwh, 0)
        / NULLIF(COALESCE(p.production_ton, 0), 0),
        4
    ) AS electricity_kwh_per_ton,

    ROUND(
        COALESCE(e.natural_gas_m3, 0)
        / NULLIF(COALESCE(p.production_ton, 0), 0),
        4
    ) AS natural_gas_m3_per_ton,

    ROUND(
        COALESCE(e.energy_cost, 0),
        2
    ) AS energy_cost,

    COALESCE(
        ms.maintenance_events,
        0
    ) AS maintenance_events,

    ROUND(
        COALESCE(ms.maintenance_cost, 0),
        2
    ) AS maintenance_cost,

    ROUND(
        COALESCE(ms.maintenance_hours, 0),
        2
    ) AS maintenance_hours

FROM production_unit pu
LEFT JOIN production p
    ON pu.production_unit_id = p.production_unit_id
LEFT JOIN energy e
    ON pu.production_unit_id = e.production_unit_id
LEFT JOIN maintenance_summary ms
    ON pu.production_unit_id = ms.production_unit_id;

