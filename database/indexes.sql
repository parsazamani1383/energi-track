-- EnergiTrack
-- Database Indexes
-- PostgreSQL

CREATE INDEX idx_equipment_production_unit
ON equipment(production_unit_id);

CREATE INDEX idx_material_consumption_production_record
ON material_consumption(production_record_id);

CREATE INDEX idx_maintenance_equipment
ON maintenance(equipment_id);

CREATE INDEX idx_energy_tariff_source
ON energy_tariff(energy_source_id);
