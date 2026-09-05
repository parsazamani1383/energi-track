-- EnergiTrack
-- Sample Data - Part 1: Base Data
-- PostgreSQL

-- =========================================================
-- 1. Production Units
-- =========================================================

INSERT INTO production_unit
(name, code, description, capacity, status, location)
VALUES
(
'Hot Rolling Unit',
'HRU-01',
'Production unit for manufacturing hot rolled steel sheets.',
120.00,
'Active',
'Production Hall A'
),
(
'Galvanizing Unit',
'GLV-01',
'Production unit for manufacturing galvanized steel sheets.',
80.00,
'Active',
'Production Hall B'
),
(
'Color Coating Unit',
'CCU-01',
'Production unit for manufacturing color-coated steel sheets.',
60.00,
'Active',
'Production Hall C'
)
ON CONFLICT DO NOTHING;

-- =========================================================
-- 2. Products
-- =========================================================

INSERT INTO product
(name, code, type, unit_of_measure, description)
VALUES
(
'Hot Rolled Sheet',
'PRD-HR',
'Hot Rolled',
'ton',
'Hot rolled steel sheet.'
),
(
'Galvanized Sheet',
'PRD-GV',
'Galvanized',
'ton',
'Zinc-coated steel sheet.'
),
(
'Color-Coated Sheet',
'PRD-CC',
'Color Coated',
'ton',
'Color-coated steel sheet.'
)
ON CONFLICT DO NOTHING;

-- =========================================================
-- 3. Production Unit - Product
-- =========================================================

INSERT INTO production_unit_product
(production_unit_id, product_id, capacity)
SELECT pu.production_unit_id, p.product_id, v.capacity
FROM (VALUES
    ('HRU-01', 'PRD-HR', 120.00::NUMERIC),
    ('GLV-01', 'PRD-GV', 80.00::NUMERIC),
    ('CCU-01', 'PRD-CC', 60.00::NUMERIC)
) AS v(unit_code, product_code, capacity)
JOIN production_unit pu ON pu.code = v.unit_code
JOIN product p ON p.code = v.product_code
ON CONFLICT (production_unit_id, product_id) DO NOTHING;

-- =========================================================
-- 4. Equipment
-- =========================================================

INSERT INTO equipment
(
production_unit_id,
name,
code,
type,
rated_power,
capacity,
installation_date,
status,
description
)
VALUES

-- Hot Rolling Unit
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'HRU-01'),
    'Reheating Furnace',
    'HRU-FUR-01',
    'Furnace',
    2500.00,
    120.00,
    '2022-03-15',
    'Active',
    'Main furnace used for heating steel before rolling.'
),
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'HRU-01'),
    'Roughing Mill',
    'HRU-RM-01',
    'Rolling Mill',
    3200.00,
    120.00,
    '2022-04-10',
    'Active',
    'Roughing mill for initial reduction of steel thickness.'
),
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'HRU-01'),
    'Finishing Mill',
    'HRU-FM-01',
    'Rolling Mill',
    3500.00,
    120.00,
    '2022-04-20',
    'Active',
    'Finishing mill for final rolling operations.'
),
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'HRU-01'),
    'Hydraulic Pump',
    'HRU-PMP-01',
    'Pump',
    180.00,
    120.00,
    '2022-05-02',
    'Active',
    'Hydraulic pump used in the rolling system.'
),
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'HRU-01'),
    'Air Compressor',
    'HRU-CMP-01',
    'Compressor',
    220.00,
    120.00,
    '2022-05-05',
    'Active',
    'Compressed air supply for the production unit.'
),

-- Galvanizing Unit
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'GLV-01'),
    'Galvanizing Furnace',
    'GLV-FUR-01',
    'Furnace',
    1800.00,
    80.00,
    '2023-01-12',
    'Active',
    'Heating system used in the galvanizing process.'
),
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'GLV-01'),
    'Galvanizing Line Motor',
    'GLV-MTR-01',
    'Motor',
    900.00,
    80.00,
    '2023-02-01',
    'Active',
    'Main drive motor of the galvanizing line.'
),
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'GLV-01'),
    'Zinc Coating Pump',
    'GLV-PMP-01',
    'Pump',
    160.00,
    80.00,
    '2023-02-08',
    'Active',
    'Pump used in the coating system.'
),
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'GLV-01'),
    'Air Compressor',
    'GLV-CMP-01',
    'Compressor',
    200.00,
    80.00,
    '2023-02-15',
    'Active',
    'Compressed air supply for the galvanizing line.'
),
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'GLV-01'),
    'Cooling System Pump',
    'GLV-PMP-02',
    'Pump',
    140.00,
    80.00,
    '2023-02-20',
    'Active',
    'Pump used in the cooling system.'
),

-- Color Coating Unit
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'CCU-01'),
    'Pre-Treatment Motor',
    'CCU-MTR-01',
    'Motor',
    450.00,
    60.00,
    '2023-06-10',
    'Active',
    'Drive motor for the surface preparation section.'
),
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'CCU-01'),
    'Coating Line Motor',
    'CCU-MTR-02',
    'Motor',
    700.00,
    60.00,
    '2023-06-15',
    'Active',
    'Main drive motor of the color coating line.'
),
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'CCU-01'),
    'Drying Furnace',
    'CCU-FUR-01',
    'Furnace',
    1200.00,
    60.00,
    '2023-06-20',
    'Active',
    'Drying system for coated steel sheets.'
),
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'CCU-01'),
    'Cooling Pump',
    'CCU-PMP-01',
    'Pump',
    120.00,
    60.00,
    '2023-06-25',
    'Active',
    'Cooling pump for the coating line.'
),
(
    (SELECT production_unit_id FROM production_unit WHERE code = 'CCU-01'),
    'Air Compressor',
    'CCU-CMP-01',
    'Compressor',
    180.00,
    60.00,
    '2023-06-28',
    'Active',
    'Compressed air supply for the color coating line.'
)
ON CONFLICT DO NOTHING;

-- =========================================================
-- 5. Raw Materials
-- =========================================================

INSERT INTO raw_material
(name, code, type, unit_of_measure, description)
VALUES
(
'Steel Slab',
'RM-SLAB',
'Steel',
'ton',
'Steel slab used as the primary input for hot rolling.'
),
(
'Hot Rolled Coil',
'RM-HRC',
'Steel',
'ton',
'Hot rolled coil used as input material for downstream processing.'
),
(
'Zinc',
'RM-ZINC',
'Coating',
'ton',
'Zinc used for galvanizing steel sheets.'
),
(
'Paint',
'RM-PAINT',
'Coating',
'ton',
'Coating material used for color-coated steel sheets.'
),
(
'Cleaning Chemical',
'RM-CLEAN',
'Chemical',
'ton',
'Material used for surface cleaning and preparation.'
),
(
'Protective Coating',
'RM-PROTECT',
'Coating',
'ton',
'Protective coating material used in downstream processing.'
)
ON CONFLICT DO NOTHING;

-- =========================================================
-- 6. Energy Sources
-- =========================================================

INSERT INTO energy_source
(name, code, unit_of_measure, description)
VALUES
(
'Electricity',
'ELEC',
'kWh',
'Electrical energy consumed by industrial equipment.'
),
(
'Natural Gas',
'GAS',
'm3',
'Natural gas consumed by furnaces and other applicable equipment.'
)
ON CONFLICT DO NOTHING;

-- EnergiTrack
-- Sample Data - Part 2: Energy Tariffs
-- PostgreSQL

-- =========================================================
-- Energy Tariffs
-- =========================================================

INSERT INTO energy_tariff
(energy_source_id, start_date, end_date, price_per_unit)
VALUES
-- Electricity
((SELECT energy_source_id FROM energy_source WHERE code = 'ELEC'), '2024-01-01', '2024-03-31', 0.0850),
((SELECT energy_source_id FROM energy_source WHERE code = 'ELEC'), '2024-04-01', '2024-06-30', 0.0900),
((SELECT energy_source_id FROM energy_source WHERE code = 'ELEC'), '2024-07-01', '2024-09-30', 0.0950),
((SELECT energy_source_id FROM energy_source WHERE code = 'ELEC'), '2024-10-01', '2024-12-31', 0.1000),

((SELECT energy_source_id FROM energy_source WHERE code = 'ELEC'), '2025-01-01', '2025-03-31', 0.1050),
((SELECT energy_source_id FROM energy_source WHERE code = 'ELEC'), '2025-04-01', '2025-06-30', 0.1100),
((SELECT energy_source_id FROM energy_source WHERE code = 'ELEC'), '2025-07-01', '2025-09-30', 0.1150),
((SELECT energy_source_id FROM energy_source WHERE code = 'ELEC'), '2025-10-01', '2025-12-31', 0.1200),

-- Natural Gas
((SELECT energy_source_id FROM energy_source WHERE code = 'GAS'), '2024-01-01', '2024-03-31', 0.3200),
((SELECT energy_source_id FROM energy_source WHERE code = 'GAS'), '2024-04-01', '2024-06-30', 0.3350),
((SELECT energy_source_id FROM energy_source WHERE code = 'GAS'), '2024-07-01', '2024-09-30', 0.3500),
((SELECT energy_source_id FROM energy_source WHERE code = 'GAS'), '2024-10-01', '2024-12-31', 0.3650),

((SELECT energy_source_id FROM energy_source WHERE code = 'GAS'), '2025-01-01', '2025-03-31', 0.3800),
((SELECT energy_source_id FROM energy_source WHERE code = 'GAS'), '2025-04-01', '2025-06-30', 0.3950),
((SELECT energy_source_id FROM energy_source WHERE code = 'GAS'), '2025-07-01', '2025-09-30', 0.4100),
((SELECT energy_source_id FROM energy_source WHERE code = 'GAS'), '2025-10-01', '2025-12-31', 0.4250);

-- EnergiTrack
-- Sample Data - Part 3: Maintenance
-- PostgreSQL

-- =========================================================
-- Maintenance Records
-- =========================================================

INSERT INTO maintenance
(equipment_id, start_time, end_time, type, cost, description)
VALUES

-- =========================================================
-- Hot Rolling Unit
-- =========================================================

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FUR-01'), '2024-01-08 08:00', '2024-01-08 13:00', 'Preventive', 1850.00, 'Routine inspection and cleaning of reheating furnace.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-RM-01'), '2024-01-15 14:00', '2024-01-15 20:00', 'Preventive', 2400.00, 'Inspection and lubrication of roughing mill components.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-FM-01'), '2024-01-22 07:00', '2024-01-22 15:00', 'Corrective', 4200.00, 'Replacement of worn finishing mill bearings.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-PMP-01'), '2024-02-03 09:00', '2024-02-03 12:00', 'Preventive', 950.00, 'Hydraulic pump inspection and filter replacement.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-CMP-01'), '2024-02-11 10:00', '2024-02-11 15:00', 'Preventive', 1100.00, 'Compressor inspection and air filter replacement.'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FUR-01'), '2024-02-19 06:00', '2024-02-19 16:00', 'Corrective', 6800.00, 'Repair of furnace burner control system.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-RM-01'), '2024-02-27 13:00', '2024-02-27 18:00', 'Preventive', 2100.00, 'Rolling mill alignment inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-FM-01'), '2024-03-06 08:00', '2024-03-06 14:00', 'Preventive', 2300.00, 'Inspection and lubrication of finishing stands.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-PMP-01'), '2024-03-14 11:00', '2024-03-14 15:00', 'Corrective', 1750.00, 'Hydraulic pressure issue correction.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-CMP-01'), '2024-03-23 07:00', '2024-03-23 13:00', 'Preventive', 1250.00, 'Compressor valve and pressure inspection.'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FUR-01'), '2024-04-04 06:00', '2024-04-04 14:00', 'Preventive', 1950.00, 'Furnace burner and temperature sensor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-RM-01'), '2024-04-12 09:00', '2024-04-12 17:00', 'Corrective', 5100.00, 'Replacement of damaged coupling.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-FM-01'), '2024-04-20 07:00', '2024-04-20 12:00', 'Preventive', 2200.00, 'Finishing mill lubrication and inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-PMP-01'), '2024-04-28 10:00', '2024-04-28 16:00', 'Preventive', 1150.00, 'Pump seal inspection and replacement.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-CMP-01'), '2024-05-05 08:00', '2024-05-05 14:00', 'Corrective', 2600.00, 'Compressor pressure regulator repair.'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FUR-01'), '2024-05-13 06:00', '2024-05-13 15:00', 'Preventive', 2050.00, 'Furnace refractory inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-RM-01'), '2024-05-21 12:00', '2024-05-21 19:00', 'Preventive', 2450.00, 'Roughing mill gearbox inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-FM-01'), '2024-05-29 07:00', '2024-05-29 15:00', 'Corrective', 5900.00, 'Repair of finishing mill drive system.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-PMP-01'), '2024-06-07 09:00', '2024-06-07 13:00', 'Preventive', 1000.00, 'Hydraulic system inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-CMP-01'), '2024-06-15 08:00', '2024-06-15 13:00', 'Preventive', 1200.00, 'Compressor cooling system inspection.'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FUR-01'), '2024-06-24 06:00', '2024-06-24 18:00', 'Corrective', 7200.00, 'Furnace fuel control system repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-RM-01'), '2024-07-03 10:00', '2024-07-03 16:00', 'Preventive', 2300.00, 'Roll inspection and lubrication.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-FM-01'), '2024-07-11 07:00', '2024-07-11 13:00', 'Preventive', 2150.00, 'Finishing mill bearing inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-PMP-01'), '2024-07-20 09:00', '2024-07-20 14:00', 'Corrective', 1850.00, 'Hydraulic leakage repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-CMP-01'), '2024-07-28 11:00', '2024-07-28 17:00', 'Preventive', 1350.00, 'Compressor maintenance and cleaning.'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FUR-01'), '2024-08-06 06:00', '2024-08-06 14:00', 'Preventive', 2150.00, 'Furnace temperature control inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-RM-01'), '2024-08-14 08:00', '2024-08-14 15:00', 'Corrective', 4700.00, 'Replacement of damaged rolling component.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-FM-01'), '2024-08-23 07:00', '2024-08-23 16:00', 'Preventive', 2500.00, 'Finishing mill alignment and lubrication.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-PMP-01'), '2024-08-31 10:00', '2024-08-31 14:00', 'Preventive', 1050.00, 'Pump inspection and filter replacement.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-CMP-01'), '2024-09-08 09:00', '2024-09-08 15:00', 'Corrective', 2900.00, 'Compressor motor repair.'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FUR-01'), '2024-09-16 06:00', '2024-09-16 15:00', 'Preventive', 2250.00, 'Furnace inspection and burner cleaning.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-RM-01'), '2024-09-24 11:00', '2024-09-24 18:00', 'Preventive', 2350.00, 'Gearbox lubrication and inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-FM-01'), '2024-10-02 07:00', '2024-10-02 13:00', 'Corrective', 5300.00, 'Finishing mill drive repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-PMP-01'), '2024-10-10 08:00', '2024-10-10 13:00', 'Preventive', 1100.00, 'Hydraulic pump maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-CMP-01'), '2024-10-18 10:00', '2024-10-18 16:00', 'Preventive', 1300.00, 'Compressor pressure system inspection.'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FUR-01'), '2024-10-27 06:00', '2024-10-27 17:00', 'Corrective', 6400.00, 'Furnace burner replacement.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-RM-01'), '2024-11-04 09:00', '2024-11-04 15:00', 'Preventive', 2200.00, 'Roughing mill preventive maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-FM-01'), '2024-11-12 07:00', '2024-11-12 14:00', 'Preventive', 2400.00, 'Finishing mill inspection and lubrication.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-PMP-01'), '2024-11-21 10:00', '2024-11-21 15:00', 'Corrective', 1950.00, 'Hydraulic valve replacement.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-CMP-01'), '2024-11-29 08:00', '2024-11-29 14:00', 'Preventive', 1250.00, 'Compressor maintenance.'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FUR-01'), '2024-12-07 06:00', '2024-12-07 14:00', 'Preventive', 2300.00, 'Annual furnace inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-RM-01'), '2024-12-15 10:00', '2024-12-15 18:00', 'Corrective', 4900.00, 'Repair of rolling mill gearbox.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-FM-01'), '2024-12-23 07:00', '2024-12-23 13:00', 'Preventive', 2150.00, 'Finishing mill inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-PMP-01'), '2024-12-27 09:00', '2024-12-27 14:00', 'Preventive', 1050.00, 'Hydraulic system inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-CMP-01'), '2024-12-30 11:00', '2024-12-30 17:00', 'Corrective', 2800.00, 'Compressor motor repair.'),

-- =========================================================
-- Galvanizing Unit
-- =========================================================

((SELECT equipment_id FROM equipment WHERE code = 'GLV-FUR-01'), '2024-01-12 07:00', '2024-01-12 15:00', 'Preventive', 1700.00, 'Galvanizing furnace inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-MTR-01'), '2024-01-25 09:00', '2024-01-25 14:00', 'Preventive', 1450.00, 'Main line motor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-01'), '2024-02-08 10:00', '2024-02-08 14:00', 'Corrective', 2100.00, 'Zinc coating pump seal replacement.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-CMP-01'), '2024-02-17 08:00', '2024-02-17 14:00', 'Preventive', 1200.00, 'Compressor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-02'), '2024-02-28 09:00', '2024-02-28 13:00', 'Preventive', 950.00, 'Cooling pump maintenance.'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-FUR-01'), '2024-03-09 06:00', '2024-03-09 15:00', 'Corrective', 5600.00, 'Furnace temperature control repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-MTR-01'), '2024-03-18 10:00', '2024-03-18 16:00', 'Preventive', 1500.00, 'Motor bearing inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-01'), '2024-03-27 08:00', '2024-03-27 13:00', 'Preventive', 1100.00, 'Coating pump inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-CMP-01'), '2024-04-06 09:00', '2024-04-06 15:00', 'Corrective', 2400.00, 'Compressor valve repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-02'), '2024-04-15 11:00', '2024-04-15 15:00', 'Preventive', 1000.00, 'Cooling system pump inspection.'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-FUR-01'), '2024-04-24 07:00', '2024-04-24 16:00', 'Preventive', 1850.00, 'Furnace burner inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-MTR-01'), '2024-05-03 09:00', '2024-05-03 15:00', 'Corrective', 3200.00, 'Motor coupling replacement.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-01'), '2024-05-12 10:00', '2024-05-12 14:00', 'Preventive', 1050.00, 'Zinc pump maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-CMP-01'), '2024-05-20 08:00', '2024-05-20 14:00', 'Preventive', 1250.00, 'Compressor cooling inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-02'), '2024-05-29 11:00', '2024-05-29 16:00', 'Corrective', 1900.00, 'Cooling pump motor repair.'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-FUR-01'), '2024-06-08 06:00', '2024-06-08 15:00', 'Corrective', 6100.00, 'Furnace burner control repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-MTR-01'), '2024-06-17 09:00', '2024-06-17 15:00', 'Preventive', 1550.00, 'Main drive motor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-01'), '2024-06-26 08:00', '2024-06-26 13:00', 'Preventive', 1150.00, 'Coating pump filter replacement.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-CMP-01'), '2024-07-05 10:00', '2024-07-05 16:00', 'Corrective', 2700.00, 'Compressor pressure system repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-02'), '2024-07-14 09:00', '2024-07-14 13:00', 'Preventive', 950.00, 'Cooling pump inspection.'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-FUR-01'), '2024-07-23 07:00', '2024-07-23 16:00', 'Preventive', 1900.00, 'Furnace refractory inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-MTR-01'), '2024-08-01 10:00', '2024-08-01 17:00', 'Corrective', 3500.00, 'Main motor bearing replacement.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-01'), '2024-08-10 08:00', '2024-08-10 13:00', 'Preventive', 1100.00, 'Zinc pump maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-CMP-01'), '2024-08-19 09:00', '2024-08-19 15:00', 'Preventive', 1300.00, 'Compressor maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-02'), '2024-08-28 11:00', '2024-08-28 16:00', 'Corrective', 2000.00, 'Cooling pump seal repair.'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-FUR-01'), '2024-09-06 06:00', '2024-09-06 15:00', 'Corrective', 5800.00, 'Galvanizing furnace repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-MTR-01'), '2024-09-15 09:00', '2024-09-15 15:00', 'Preventive', 1500.00, 'Motor lubrication and inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-01'), '2024-09-24 08:00', '2024-09-24 13:00', 'Preventive', 1050.00, 'Coating pump inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-CMP-01'), '2024-10-03 10:00', '2024-10-03 16:00', 'Corrective', 2550.00, 'Compressor motor repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-02'), '2024-10-12 09:00', '2024-10-12 14:00', 'Preventive', 1000.00, 'Cooling pump inspection.'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-FUR-01'), '2024-10-21 07:00', '2024-10-21 16:00', 'Preventive', 1950.00, 'Furnace burner inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-MTR-01'), '2024-10-30 10:00', '2024-10-30 17:00', 'Corrective', 3300.00, 'Motor coupling repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-01'), '2024-11-08 08:00', '2024-11-08 14:00', 'Preventive', 1150.00, 'Coating pump maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-CMP-01'), '2024-11-17 09:00', '2024-11-17 15:00', 'Preventive', 1250.00, 'Compressor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-02'), '2024-11-26 11:00', '2024-11-26 16:00', 'Corrective', 1850.00, 'Cooling pump repair.'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-FUR-01'), '2024-12-05 06:00', '2024-12-05 15:00', 'Corrective', 5900.00, 'Furnace control system repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-MTR-01'), '2024-12-14 09:00', '2024-12-14 15:00', 'Preventive', 1550.00, 'Main motor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-01'), '2024-12-23 08:00', '2024-12-23 13:00', 'Preventive', 1100.00, 'Coating pump inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-CMP-01'), '2024-12-27 10:00', '2024-12-27 16:00', 'Corrective', 2650.00, 'Compressor valve repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-02'), '2024-12-30 09:00', '2024-12-30 14:00', 'Preventive', 950.00, 'Cooling pump maintenance.'),

-- =========================================================
-- Color Coating Unit
-- =========================================================

((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-01'), '2024-01-10 08:00', '2024-01-10 13:00', 'Preventive', 1000.00, 'Pre-treatment motor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-02'), '2024-01-20 09:00', '2024-01-20 15:00', 'Preventive', 1500.00, 'Coating line motor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-FUR-01'), '2024-01-29 07:00', '2024-01-29 14:00', 'Corrective', 3400.00, 'Drying furnace temperature control repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-PMP-01'), '2024-02-09 10:00', '2024-02-09 14:00', 'Preventive', 850.00, 'Cooling pump inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-CMP-01'), '2024-02-18 08:00', '2024-02-18 14:00', 'Preventive', 1100.00, 'Air compressor maintenance.'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-01'), '2024-02-27 09:00', '2024-02-27 14:00', 'Corrective', 1800.00, 'Motor bearing replacement.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-02'), '2024-03-07 10:00', '2024-03-07 17:00', 'Preventive', 1650.00, 'Coating line motor lubrication.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-FUR-01'), '2024-03-16 07:00', '2024-03-16 16:00', 'Preventive', 1900.00, 'Drying furnace inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-PMP-01'), '2024-03-25 09:00', '2024-03-25 13:00', 'Corrective', 1550.00, 'Cooling pump seal repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-CMP-01'), '2024-04-04 08:00', '2024-04-04 14:00', 'Preventive', 1150.00, 'Compressor inspection.'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-01'), '2024-04-13 10:00', '2024-04-13 15:00', 'Preventive', 1050.00, 'Pre-treatment motor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-02'), '2024-04-22 09:00', '2024-04-22 16:00', 'Corrective', 2800.00, 'Coating motor coupling repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-FUR-01'), '2024-05-01 07:00', '2024-05-01 15:00', 'Preventive', 1950.00, 'Drying furnace burner inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-PMP-01'), '2024-05-10 11:00', '2024-05-10 15:00', 'Preventive', 900.00, 'Cooling pump maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-CMP-01'), '2024-05-19 08:00', '2024-05-19 14:00', 'Corrective', 2200.00, 'Compressor pressure valve repair.'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-01'), '2024-05-28 09:00', '2024-05-28 14:00', 'Preventive', 1050.00, 'Motor lubrication and inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-02'), '2024-06-06 10:00', '2024-06-06 17:00', 'Preventive', 1700.00, 'Coating line drive inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-FUR-01'), '2024-06-15 07:00', '2024-06-15 16:00', 'Corrective', 4100.00, 'Drying furnace control repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-PMP-01'), '2024-06-24 09:00', '2024-06-24 13:00', 'Preventive', 900.00, 'Cooling pump inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-CMP-01'), '2024-07-03 08:00', '2024-07-03 14:00', 'Preventive', 1200.00, 'Compressor maintenance.'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-01'), '2024-07-12 10:00', '2024-07-12 15:00', 'Corrective', 1950.00, 'Pre-treatment motor repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-02'), '2024-07-21 09:00', '2024-07-21 16:00', 'Preventive', 1750.00, 'Coating motor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-FUR-01'), '2024-07-30 07:00', '2024-07-30 15:00', 'Preventive', 2000.00, 'Drying furnace inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-PMP-01'), '2024-08-08 11:00', '2024-08-08 15:00', 'Corrective', 1450.00, 'Cooling pump seal replacement.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-CMP-01'), '2024-08-17 08:00', '2024-08-17 14:00', 'Preventive', 1150.00, 'Compressor inspection.'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-01'), '2024-08-26 09:00', '2024-08-26 14:00', 'Preventive', 1050.00, 'Motor inspection and lubrication.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-02'), '2024-09-04 10:00', '2024-09-04 17:00', 'Corrective', 3100.00, 'Coating line motor bearing repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-FUR-01'), '2024-09-13 07:00', '2024-09-13 16:00', 'Preventive', 1900.00, 'Drying furnace maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-PMP-01'), '2024-09-22 09:00', '2024-09-22 13:00', 'Preventive', 900.00, 'Cooling pump inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-CMP-01'), '2024-10-01 08:00', '2024-10-01 14:00', 'Corrective', 2350.00, 'Compressor motor repair.'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-01'), '2024-10-10 10:00', '2024-10-10 15:00', 'Preventive', 1050.00, 'Pre-treatment motor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-02'), '2024-10-19 09:00', '2024-10-19 16:00', 'Preventive', 1800.00, 'Coating line motor maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-FUR-01'), '2024-10-28 07:00', '2024-10-28 15:00', 'Corrective', 3900.00, 'Drying furnace burner repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-PMP-01'), '2024-11-06 11:00', '2024-11-06 15:00', 'Preventive', 950.00, 'Cooling pump inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-CMP-01'), '2024-11-15 08:00', '2024-11-15 14:00', 'Preventive', 1200.00, 'Compressor maintenance.'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-01'), '2024-11-24 09:00', '2024-11-24 14:00', 'Corrective', 1850.00, 'Pre-treatment motor bearing repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-02'), '2024-12-03 10:00', '2024-12-03 17:00', 'Preventive', 1750.00, 'Coating motor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-FUR-01'), '2024-12-12 07:00', '2024-12-12 16:00', 'Preventive', 2050.00, 'Annual drying furnace inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-PMP-01'), '2024-12-21 09:00', '2024-12-21 13:00', 'Corrective', 1500.00, 'Cooling pump repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-CMP-01'), '2024-12-29 08:00', '2024-12-29 14:00', 'Preventive', 1250.00, 'Compressor annual inspection.'),

-- =========================================================
-- Additional Maintenance Records - 2025
-- =========================================================

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FUR-01'), '2025-01-07 06:00', '2025-01-07 14:00', 'Preventive', 2400.00, 'Annual reheating furnace inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-RM-01'), '2025-01-16 09:00', '2025-01-16 16:00', 'Corrective', 5200.00, 'Roughing mill drive repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-FM-01'), '2025-01-25 07:00', '2025-01-25 15:00', 'Preventive', 2450.00, 'Finishing mill maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-PMP-01'), '2025-02-03 10:00', '2025-02-03 15:00', 'Preventive', 1100.00, 'Hydraulic pump inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-CMP-01'), '2025-02-12 08:00', '2025-02-12 14:00', 'Corrective', 2850.00, 'Compressor motor repair.'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-FUR-01'), '2025-02-21 06:00', '2025-02-21 15:00', 'Preventive', 2000.00, 'Galvanizing furnace inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-MTR-01'), '2025-03-02 09:00', '2025-03-02 16:00', 'Preventive', 1600.00, 'Main drive motor maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-01'), '2025-03-11 08:00', '2025-03-11 13:00', 'Corrective', 2250.00, 'Zinc coating pump repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-CMP-01'), '2025-03-20 10:00', '2025-03-20 16:00', 'Preventive', 1350.00, 'Compressor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-02'), '2025-03-29 09:00', '2025-03-29 14:00', 'Preventive', 1000.00, 'Cooling pump maintenance.'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-01'), '2025-04-07 08:00', '2025-04-07 14:00', 'Preventive', 1100.00, 'Pre-treatment motor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-02'), '2025-04-16 09:00', '2025-04-16 17:00', 'Corrective', 3200.00, 'Coating motor drive repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-FUR-01'), '2025-04-25 07:00', '2025-04-25 16:00', 'Preventive', 2100.00, 'Drying furnace inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-PMP-01'), '2025-05-04 10:00', '2025-05-04 14:00', 'Preventive', 950.00, 'Cooling pump inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-CMP-01'), '2025-05-13 08:00', '2025-05-13 15:00', 'Corrective', 2450.00, 'Compressor repair.'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FUR-01'), '2025-05-22 06:00', '2025-05-22 16:00', 'Corrective', 7100.00, 'Reheating furnace control system repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-RM-01'), '2025-06-01 09:00', '2025-06-01 15:00', 'Preventive', 2350.00, 'Roughing mill inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-FM-01'), '2025-06-10 07:00', '2025-06-10 14:00', 'Preventive', 2500.00, 'Finishing mill lubrication.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-PMP-01'), '2025-06-19 10:00', '2025-06-19 15:00', 'Corrective', 1800.00, 'Hydraulic system repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-CMP-01'), '2025-06-28 08:00', '2025-06-28 14:00', 'Preventive', 1300.00, 'Compressor maintenance.'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-FUR-01'), '2025-07-07 06:00', '2025-07-07 16:00', 'Corrective', 6200.00, 'Galvanizing furnace burner repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-MTR-01'), '2025-07-16 09:00', '2025-07-16 15:00', 'Preventive', 1650.00, 'Main motor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-01'), '2025-07-25 08:00', '2025-07-25 14:00', 'Preventive', 1200.00, 'Zinc pump inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-CMP-01'), '2025-08-03 10:00', '2025-08-03 16:00', 'Corrective', 2750.00, 'Compressor valve repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-02'), '2025-08-12 09:00', '2025-08-12 13:00', 'Preventive', 1050.00, 'Cooling pump inspection.'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-01'), '2025-08-21 08:00', '2025-08-21 14:00', 'Preventive', 1150.00, 'Pre-treatment motor maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-02'), '2025-08-30 09:00', '2025-08-30 17:00', 'Corrective', 3400.00, 'Coating line motor repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-FUR-01'), '2025-09-08 07:00', '2025-09-08 16:00', 'Preventive', 2150.00, 'Drying furnace inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-PMP-01'), '2025-09-17 10:00', '2025-09-17 14:00', 'Preventive', 950.00, 'Cooling pump maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'CCU-CMP-01'), '2025-09-26 08:00', '2025-09-26 15:00', 'Corrective', 2550.00, 'Compressor motor repair.'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FUR-01'), '2025-10-05 06:00', '2025-10-05 15:00', 'Preventive', 2500.00, 'Furnace annual inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-RM-01'), '2025-10-14 09:00', '2025-10-14 17:00', 'Corrective', 5400.00, 'Roughing mill gearbox repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-FM-01'), '2025-10-23 07:00', '2025-10-23 14:00', 'Preventive', 2550.00, 'Finishing mill inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-PMP-01'), '2025-11-01 10:00', '2025-11-01 15:00', 'Preventive', 1150.00, 'Hydraulic pump maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'HRU-CMP-01'), '2025-11-10 08:00', '2025-11-10 14:00', 'Corrective', 2950.00, 'Compressor repair.'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-FUR-01'), '2025-11-19 06:00', '2025-11-19 15:00', 'Preventive', 2050.00, 'Galvanizing furnace inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-MTR-01'), '2025-11-28 09:00', '2025-11-28 16:00', 'Preventive', 1700.00, 'Main motor maintenance.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-01'), '2025-12-07 08:00', '2025-12-07 14:00', 'Corrective', 2300.00, 'Zinc coating pump repair.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-CMP-01'), '2025-12-16 10:00', '2025-12-16 16:00', 'Preventive', 1400.00, 'Compressor inspection.'),
((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-02'), '2025-12-25 09:00', '2025-12-25 14:00', 'Preventive', 1050.00, 'Cooling pump maintenance.');

INSERT INTO maintenance
    (equipment_id, start_time, end_time, type, cost, description)
VALUES

-- Additional Maintenance Records

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FUR-01'), '2025-01-18 02:00:00', '2025-01-18 08:00:00',
 'Preventive', 18500.00,
 'Reheating furnace inspection and burner cleaning'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-RM-01'), '2025-02-07 22:00:00', '2025-02-08 06:00:00',
 'Corrective', 32000.00,
 'Roughing mill hydraulic system repair'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FM-01'), '2025-02-21 01:00:00', '2025-02-21 07:00:00',
 'Preventive', 21000.00,
 'Finishing mill inspection and roller alignment'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-PMP-01'), '2025-03-12 03:00:00', '2025-03-12 07:00:00',
 'Preventive', 9500.00,
 'Hydraulic pump inspection and filter replacement'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-CMP-01'), '2025-03-28 23:00:00', '2025-03-29 05:00:00',
 'Corrective', 14500.00,
 'Air compressor pressure system repair'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-FUR-01'), '2025-04-16 02:00:00', '2025-04-16 09:00:00',
 'Preventive', 15200.00,
 'Galvanizing furnace burner inspection'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-MTR-01'), '2025-05-03 00:00:00', '2025-05-03 06:00:00',
 'Corrective', 19800.00,
 'Galvanizing line motor bearing replacement'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-01'), '2025-05-19 01:00:00', '2025-05-19 05:00:00',
 'Preventive', 7800.00,
 'Zinc coating pump inspection'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-CMP-01'), '2025-06-08 22:00:00', '2025-06-09 04:00:00',
 'Preventive', 11200.00,
 'Air compressor maintenance and valve inspection'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-PMP-02'), '2025-06-24 02:00:00', '2025-06-24 07:00:00',
 'Corrective', 12500.00,
 'Cooling system pump repair'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-01'), '2025-07-15 23:00:00', '2025-07-16 05:00:00',
 'Preventive', 8500.00,
 'Pre-treatment motor inspection'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-MTR-02'), '2025-08-02 01:00:00', '2025-08-02 06:00:00',
 'Corrective', 17600.00,
 'Coating line motor electrical repair'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-FUR-01'), '2025-08-17 22:00:00', '2025-08-18 06:00:00',
 'Preventive', 13800.00,
 'Drying furnace inspection and cleaning'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-PMP-01'), '2025-09-05 02:00:00', '2025-09-05 05:00:00',
 'Preventive', 6200.00,
 'Cooling pump inspection'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-CMP-01'), '2025-09-23 23:00:00', '2025-09-24 05:00:00',
 'Corrective', 10900.00,
 'Air compressor motor repair'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FUR-01'), '2025-10-11 01:00:00', '2025-10-11 07:00:00',
 'Preventive', 19200.00,
 'Reheating furnace preventive maintenance'),

((SELECT equipment_id FROM equipment WHERE code = 'HRU-FM-01'), '2025-10-29 22:00:00', '2025-10-30 05:00:00',
 'Corrective', 27500.00,
 'Finishing mill drive system repair'),

((SELECT equipment_id FROM equipment WHERE code = 'GLV-MTR-01'), '2025-11-14 02:00:00', '2025-11-14 08:00:00',
 'Preventive', 13400.00,
 'Galvanizing line motor inspection'),

((SELECT equipment_id FROM equipment WHERE code = 'CCU-FUR-01'), '2025-12-06 23:00:00', '2025-12-07 06:00:00',
 'Corrective', 22100.00,
 'Drying furnace temperature control repair');

-- EnergiTrack
-- Sample Data - Part 4: Production Records
-- PostgreSQL

-- =========================================================
-- Production Records
-- Hourly production data for 2024-2025
-- =========================================================

-- =========================================================
-- Hot Rolling Unit
-- =========================================================
INSERT INTO production_record
    (production_unit_id, product_id, timestamp,
     production_quantity, scrap_quantity)
SELECT
    (SELECT production_unit_id FROM production_unit WHERE code = 'HRU-01'),
    (SELECT product_id FROM product WHERE code = 'PRD-HR'),
    h.timestamp,
    ROUND(
        CASE
            WHEN h.corrective_maintenance THEN 0
            WHEN h.preventive_maintenance
                THEN (h.base_quantity * (0.65 + RANDOM() * 0.15))::NUMERIC
            ELSE (h.base_quantity)::NUMERIC
        END
    , 2),
    0
FROM (
    SELECT
        t.timestamp,

        CASE
            WHEN EXTRACT(HOUR FROM t.timestamp) BETWEEN 0 AND 5
                THEN 70 + RANDOM() * 8
            WHEN EXTRACT(HOUR FROM t.timestamp) BETWEEN 6 AND 21
                THEN 95 + RANDOM() * 20
            ELSE 80 + RANDOM() * 10
        END AS base_quantity,

        EXISTS (
            SELECT 1
            FROM maintenance m
            JOIN equipment e
                ON e.equipment_id = m.equipment_id
            WHERE e.production_unit_id = (SELECT production_unit_id FROM production_unit WHERE code = 'HRU-01')
              AND e.type IN ('Furnace', 'Rolling Mill')
              AND m.type = 'Corrective'
              AND m.start_time <= t.timestamp
              AND m.end_time > t.timestamp
        ) AS corrective_maintenance,

        EXISTS (
            SELECT 1
            FROM maintenance m
            JOIN equipment e
                ON e.equipment_id = m.equipment_id
            WHERE e.production_unit_id = (SELECT production_unit_id FROM production_unit WHERE code = 'HRU-01')
              AND e.type IN ('Furnace', 'Rolling Mill')
              AND m.type = 'Preventive'
              AND m.start_time <= t.timestamp
              AND m.end_time > t.timestamp
        ) AS preventive_maintenance

    FROM generate_series(
        '2024-01-01 00:00:00'::timestamp,
        '2025-12-31 23:00:00'::timestamp,
        '1 hour'
    ) AS t(timestamp)
) h;

-- =========================================================
-- Galvanizing Unit
-- =========================================================

INSERT INTO production_record
    (production_unit_id, product_id, timestamp,
     production_quantity, scrap_quantity)
SELECT
    (SELECT production_unit_id FROM production_unit WHERE code = 'GLV-01'),
    (SELECT product_id FROM product WHERE code = 'PRD-GV'),
    h.timestamp,
    ROUND(
        CASE
            WHEN h.corrective_maintenance THEN 0
            WHEN h.preventive_maintenance
                THEN (h.base_quantity * (0.65 + RANDOM() * 0.15))::NUMERIC
            ELSE (h.base_quantity)::NUMERIC
        END
    , 2),
    0
FROM (
    SELECT
        t.timestamp,

        CASE
            WHEN EXTRACT(HOUR FROM t.timestamp) BETWEEN 0 AND 5
                THEN 45 + RANDOM() * 6
            WHEN EXTRACT(HOUR FROM t.timestamp) BETWEEN 6 AND 21
                THEN 60 + RANDOM() * 12
            ELSE 50 + RANDOM() * 8
        END AS base_quantity,

        EXISTS (
            SELECT 1
            FROM maintenance m
            JOIN equipment e
                ON e.equipment_id = m.equipment_id
            WHERE e.production_unit_id = (SELECT production_unit_id FROM production_unit WHERE code = 'GLV-01')
              AND e.type IN ('Furnace', 'Motor')
              AND m.type = 'Corrective'
              AND m.start_time <= t.timestamp
              AND m.end_time > t.timestamp
        ) AS corrective_maintenance,

        EXISTS (
            SELECT 1
            FROM maintenance m
            JOIN equipment e
                ON e.equipment_id = m.equipment_id
            WHERE e.production_unit_id = (SELECT production_unit_id FROM production_unit WHERE code = 'GLV-01')
              AND e.type IN ('Furnace', 'Motor')
              AND m.type = 'Preventive'
              AND m.start_time <= t.timestamp
              AND m.end_time > t.timestamp
        ) AS preventive_maintenance

    FROM generate_series(
        '2024-01-01 00:00:00'::timestamp,
        '2025-12-31 23:00:00'::timestamp,
        '1 hour'
    ) AS t(timestamp)
) h;

-- =========================================================
-- Color Coating Unit
-- =========================================================

INSERT INTO production_record
    (production_unit_id, product_id, timestamp,
     production_quantity, scrap_quantity)
SELECT
    (SELECT production_unit_id FROM production_unit WHERE code = 'CCU-01'),
    (SELECT product_id FROM product WHERE code = 'PRD-CC'),
    h.timestamp,
    ROUND(
        CASE
            WHEN h.corrective_maintenance THEN 0
            WHEN h.preventive_maintenance
                THEN (h.base_quantity * (0.65 + RANDOM() * 0.15))::NUMERIC
            ELSE (h.base_quantity)::NUMERIC
        END
    , 2),
    0
FROM (
    SELECT
        t.timestamp,

        CASE
            WHEN EXTRACT(HOUR FROM t.timestamp) BETWEEN 0 AND 5
                THEN 32 + RANDOM() * 5
            WHEN EXTRACT(HOUR FROM t.timestamp) BETWEEN 6 AND 21
                THEN 45 + RANDOM() * 10
            ELSE 36 + RANDOM() * 6
        END AS base_quantity,

        EXISTS (
            SELECT 1
            FROM maintenance m
            JOIN equipment e
                ON e.equipment_id = m.equipment_id
            WHERE e.production_unit_id = (SELECT production_unit_id FROM production_unit WHERE code = 'CCU-01')
              AND e.type IN ('Furnace', 'Motor')
              AND m.type = 'Corrective'
              AND m.start_time <= t.timestamp
              AND m.end_time > t.timestamp
        ) AS corrective_maintenance,

        EXISTS (
            SELECT 1
            FROM maintenance m
            JOIN equipment e
                ON e.equipment_id = m.equipment_id
            WHERE e.production_unit_id = (SELECT production_unit_id FROM production_unit WHERE code = 'CCU-01')
              AND e.type IN ('Furnace', 'Motor')
              AND m.type = 'Preventive'
              AND m.start_time <= t.timestamp
              AND m.end_time > t.timestamp
        ) AS preventive_maintenance

    FROM generate_series(
        '2024-01-01 00:00:00'::timestamp,
        '2025-12-31 23:00:00'::timestamp,
        '1 hour'
    ) AS t(timestamp)
) h;

-- EnergiTrack
-- Sample Data - Part 5: Material Consumption
-- PostgreSQL

-- =========================================================
-- Material Consumption
-- =========================================================

-- ---------------------------------------------------------

-- Hot Rolled Sheet
-- Steel Slab consumption
-- Approximately 1.03 tons of slab per ton of production

-- ---------------------------------------------------------

INSERT INTO material_consumption
(
production_record_id,
raw_material_id,
quantity
)
SELECT
production_record_id,
(SELECT raw_material_id FROM raw_material WHERE code = 'RM-SLAB') AS raw_material_id,
ROUND(
(
production_quantity
* (1.02 + RANDOM() * 0.04)
)::NUMERIC,
2
) AS quantity
FROM production_record
WHERE production_unit_id = (SELECT production_unit_id FROM production_unit WHERE code = 'HRU-01')
AND product_id = (SELECT product_id FROM product WHERE code = 'PRD-HR');

-- ---------------------------------------------------------

-- Galvanized Sheet
-- Hot Rolled Coil consumption

-- ---------------------------------------------------------

INSERT INTO material_consumption
(
production_record_id,
raw_material_id,
quantity
)
SELECT
production_record_id,
(SELECT raw_material_id FROM raw_material WHERE code = 'RM-HRC') AS raw_material_id,
ROUND(
(
production_quantity
* (1.01 + RANDOM() * 0.03)
)::NUMERIC,
2
) AS quantity
FROM production_record
WHERE production_unit_id = (SELECT production_unit_id FROM production_unit WHERE code = 'GLV-01')
AND product_id = (SELECT product_id FROM product WHERE code = 'PRD-GV');

-- ---------------------------------------------------------

-- Galvanized Sheet
-- Zinc consumption
-- Approximately 2% - 4% of production

-- ---------------------------------------------------------

INSERT INTO material_consumption
(
production_record_id,
raw_material_id,
quantity
)
SELECT
production_record_id,
(SELECT raw_material_id FROM raw_material WHERE code = 'RM-ZINC') AS raw_material_id,
ROUND(
(
production_quantity
* (0.02 + RANDOM() * 0.02)
)::NUMERIC,
2
) AS quantity
FROM production_record
WHERE production_unit_id = (SELECT production_unit_id FROM production_unit WHERE code = 'GLV-01')
AND product_id = (SELECT product_id FROM product WHERE code = 'PRD-GV');

-- ---------------------------------------------------------

-- Color-Coated Sheet
-- Hot Rolled Coil as base material

-- ---------------------------------------------------------

INSERT INTO material_consumption
(
production_record_id,
raw_material_id,
quantity
)
SELECT
production_record_id,
(SELECT raw_material_id FROM raw_material WHERE code = 'RM-HRC') AS raw_material_id,
ROUND(
(
production_quantity
* (1.01 + RANDOM() * 0.03)
)::NUMERIC,
2
) AS quantity
FROM production_record
WHERE production_unit_id = (SELECT production_unit_id FROM production_unit WHERE code = 'CCU-01')
AND product_id = (SELECT product_id FROM product WHERE code = 'PRD-CC');

-- ---------------------------------------------------------

-- Color-Coated Sheet
-- Paint consumption
-- Approximately 1% - 3% of production

-- ---------------------------------------------------------

INSERT INTO material_consumption
(
production_record_id,
raw_material_id,
quantity
)
SELECT
production_record_id,
(SELECT raw_material_id FROM raw_material WHERE code = 'RM-PAINT') AS raw_material_id,
ROUND(
(
production_quantity
* (0.01 + RANDOM() * 0.02)
)::NUMERIC,
2
) AS quantity
FROM production_record
WHERE production_unit_id = (SELECT production_unit_id FROM production_unit WHERE code = 'CCU-01')
AND product_id = (SELECT product_id FROM product WHERE code = 'PRD-CC');

-- ---------------------------------------------------------

-- Color-Coated Sheet
-- Protective Coating consumption
-- Approximately 0.5% - 1.5% of production

-- ---------------------------------------------------------

INSERT INTO material_consumption
(
production_record_id,
raw_material_id,
quantity
)
SELECT
production_record_id,
(SELECT raw_material_id FROM raw_material WHERE code = 'RM-PROTECT') AS raw_material_id,
ROUND(
(
production_quantity
* (0.005 + RANDOM() * 0.01)
)::NUMERIC,
2
) AS quantity
FROM production_record
WHERE production_unit_id = (SELECT production_unit_id FROM production_unit WHERE code = 'CCU-01')
AND product_id = (SELECT product_id FROM product WHERE code = 'PRD-CC');

-- =========================================================
-- Verification
-- =========================================================

SELECT COUNT(*) AS total_material_consumption_records
FROM material_consumption;

-- Check material consumption by material
SELECT
rm.name AS raw_material,
COUNT(mc.material_consumption_id) AS records,
ROUND(SUM(mc.quantity), 2) AS total_quantity
FROM material_consumption mc
JOIN raw_material rm
ON mc.raw_material_id = rm.raw_material_id
GROUP BY rm.raw_material_id, rm.name
ORDER BY rm.raw_material_id;

-- EnergiTrack
-- Sample Data - Part 6: Energy Consumption
-- PostgreSQL

-- =========================================================
-- Energy Consumption
-- =========================================================
-- Hourly energy consumption for every equipment
-- Electricity and Natural Gas
-- =========================================================

-- =========================================================
-- Electricity Consumption
-- =========================================================

INSERT INTO energy_consumption
(
equipment_id,
energy_source_id,
timestamp,
consumption_amount
)

SELECT
e.equipment_id,
(SELECT energy_source_id FROM energy_source WHERE code = 'ELEC') AS energy_source_id,
h.ts AS timestamp,

ROUND(
    (
        e.rated_power
        * (
            CASE
                WHEN EXTRACT(HOUR FROM h.ts)
                     BETWEEN 0 AND 5
                    THEN 0.35 + RANDOM() * 0.15

                WHEN EXTRACT(HOUR FROM h.ts)
                     BETWEEN 6 AND 21
                    THEN 0.65 + RANDOM() * 0.25

                ELSE
                    0.45 + RANDOM() * 0.20
            END
        )
    )::NUMERIC,
    2
) AS consumption_amount

FROM equipment e

CROSS JOIN generate_series(
TIMESTAMP '2024-01-01 00:00:00',
TIMESTAMP '2025-12-31 23:00:00',
INTERVAL '1 hour'
) AS h(ts);

-- =========================================================
-- Natural Gas Consumption
-- =========================================================
-- Mainly used by furnaces.
-- Non-furnace equipment has very low gas consumption.
-- =========================================================

INSERT INTO energy_consumption
(
equipment_id,
energy_source_id,
timestamp,
consumption_amount
)

SELECT
e.equipment_id,
(SELECT energy_source_id FROM energy_source WHERE code = 'GAS') AS energy_source_id,
h.ts AS timestamp,


ROUND(
    (
        CASE
            WHEN e.type = 'Furnace' THEN
                e.rated_power
                * (
                    0.00020
                    + RANDOM() * 0.00015
                )

            WHEN e.type IN ('Rolling Mill', 'Motor') THEN
                e.rated_power
                * (
                    0.00001
                    + RANDOM() * 0.00001
                )

            ELSE
                e.rated_power
                * (
                    0.000005
                    + RANDOM() * 0.000005
                )
        END
    )::NUMERIC,
    2
) AS consumption_amount


FROM equipment e

CROSS JOIN generate_series(
TIMESTAMP '2024-01-01 00:00:00',
TIMESTAMP '2025-12-31 23:00:00',
INTERVAL '1 hour'
) AS h(ts);

-- =========================================================
-- Verification
-- =========================================================

SELECT
es.name AS energy_source,
COUNT(ec.energy_consumption_id) AS record_count,
ROUND(SUM(ec.consumption_amount), 2) AS total_consumption
FROM energy_consumption ec
JOIN energy_source es
ON ec.energy_source_id = es.energy_source_id
GROUP BY es.energy_source_id, es.name
ORDER BY es.energy_source_id;

-- =========================================================
-- Consumption by Equipment
-- =========================================================

SELECT
e.name AS equipment,
es.name AS energy_source,
COUNT(ec.energy_consumption_id) AS record_count,
ROUND(SUM(ec.consumption_amount), 2) AS total_consumption
FROM energy_consumption ec
JOIN equipment e
ON ec.equipment_id = e.equipment_id
JOIN energy_source es
ON ec.energy_source_id = es.energy_source_id
GROUP BY
e.equipment_id,
e.name,
es.energy_source_id,
es.name
ORDER BY
e.equipment_id,
es.energy_source_id;
