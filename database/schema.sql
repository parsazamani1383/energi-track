-- EnergiTrack
-- Steel Plant Energy Management Database
-- PostgreSQL Schema

CREATE TABLE production_unit (
    production_unit_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    capacity NUMERIC(12, 2)
        CHECK (capacity >= 0),
    status VARCHAR(30) NOT NULL
        CHECK (status IN ('Active', 'Inactive', 'Maintenance')),
    location VARCHAR(100)
);

CREATE TABLE equipment (
    equipment_id SERIAL PRIMARY KEY,
    production_unit_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,

    type VARCHAR(50) NOT NULL
        CHECK (type IN (
            'Rolling Mill',
            'Furnace',
            'Motor',
            'Pump',
            'Compressor',
            'Other'
        )),

    rated_power NUMERIC(12, 2)
        CHECK (rated_power >= 0),

    capacity NUMERIC(12, 2)
        CHECK (capacity >= 0),

    installation_date DATE,

    status VARCHAR(30) NOT NULL
        CHECK (status IN (
            'Active',
            'Inactive',
            'Maintenance'
        )),

    description TEXT,

    FOREIGN KEY (production_unit_id)
        REFERENCES production_unit(production_unit_id)
);

CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,

    type VARCHAR(50) NOT NULL
        CHECK (type IN (
            'Hot Rolled',
            'Galvanized',
            'Color Coated'
        )),

    unit_of_measure VARCHAR(20) NOT NULL
        CHECK (unit_of_measure = 'ton'),

    description TEXT
);

CREATE TABLE production_unit_product (
    production_unit_id INT NOT NULL,
    product_id INT NOT NULL,
    capacity NUMERIC(12, 2)
        CHECK (capacity >= 0),

    PRIMARY KEY (production_unit_id, product_id),

    FOREIGN KEY (production_unit_id)
        REFERENCES production_unit(production_unit_id),

    FOREIGN KEY (product_id)
        REFERENCES product(product_id)
);

CREATE TABLE production_record (
    production_record_id SERIAL PRIMARY KEY,
    production_unit_id INT NOT NULL,
    product_id INT NOT NULL,
    timestamp TIMESTAMP NOT NULL,

    production_quantity NUMERIC(12, 2) NOT NULL
        CHECK (production_quantity >= 0),

    scrap_quantity NUMERIC(12, 2) NOT NULL DEFAULT 0
        CHECK (scrap_quantity >= 0),

    FOREIGN KEY (production_unit_id)
        REFERENCES production_unit(production_unit_id),

    FOREIGN KEY (product_id)
        REFERENCES product(product_id)
);

CREATE TABLE raw_material (
    raw_material_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    type VARCHAR(50) NOT NULL,
    unit_of_measure VARCHAR(20) NOT NULL
        CHECK (unit_of_measure = 'ton'),
    description TEXT
);

CREATE TABLE material_consumption (
    material_consumption_id SERIAL PRIMARY KEY,
    production_record_id INT NOT NULL,
    raw_material_id INT NOT NULL,
    quantity NUMERIC(12, 2) NOT NULL
        CHECK (quantity >= 0),

    FOREIGN KEY (production_record_id)
        REFERENCES production_record(production_record_id),

    FOREIGN KEY (raw_material_id)
        REFERENCES raw_material(raw_material_id)
);

CREATE TABLE energy_source (
    energy_source_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    code VARCHAR(30) UNIQUE NOT NULL,
    unit_of_measure VARCHAR(20) NOT NULL,
    description TEXT
);

CREATE TABLE energy_consumption (
    energy_consumption_id SERIAL PRIMARY KEY,
    equipment_id INT NOT NULL,
    energy_source_id INT NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    consumption_amount NUMERIC(14, 2) NOT NULL
        CHECK (consumption_amount >= 0),

    FOREIGN KEY (equipment_id)
        REFERENCES equipment(equipment_id),

    FOREIGN KEY (energy_source_id)
        REFERENCES energy_source(energy_source_id)
);

CREATE TABLE energy_tariff (
    energy_tariff_id SERIAL PRIMARY KEY,
    energy_source_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price_per_unit NUMERIC(12, 4) NOT NULL
        CHECK (price_per_unit >= 0),

    CHECK (end_date >= start_date),

    FOREIGN KEY (energy_source_id)
        REFERENCES energy_source(energy_source_id)
);
CREATE TABLE maintenance (
    maintenance_id SERIAL PRIMARY KEY,
    equipment_id INT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,

    type VARCHAR(30) NOT NULL
        CHECK (type IN ('Preventive', 'Corrective')),

    cost NUMERIC(12, 2)
        CHECK (cost >= 0),

    description TEXT,

    CHECK (end_time >= start_time),

    FOREIGN KEY (equipment_id)
        REFERENCES equipment(equipment_id)
);
