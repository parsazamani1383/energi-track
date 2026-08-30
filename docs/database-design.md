# EnergiTrack — Database Design

## Entities

### Production Unit

* `production_unit_id` — Primary Key
* `name`
* `code`
* `description`
* `capacity`
* `status`
* `location`

### Equipment

* `equipment_id` — Primary Key
* `production_unit_id` — Foreign Key
* `name`
* `code`
* `type`
* `rated_power`
* `capacity`
* `installation_date`
* `status`
* `description`

### Product

* `product_id` — Primary Key
* `name`
* `code`
* `type`
* `unit_of_measure`
* `description`

### Production Record

* `production_record_id` — Primary Key
* `production_unit_id` — Foreign Key
* `product_id` — Foreign Key
* `timestamp`
* `production_quantity`
* `scrap_quantity`

### Raw Material

* `raw_material_id` — Primary Key
* `name`
* `code`
* `type`
* `unit_of_measure`
* `description`

### Material Consumption

* `material_consumption_id` — Primary Key
* `production_record_id` — Foreign Key
* `raw_material_id` — Foreign Key
* `quantity`

### Energy Source

* `energy_source_id` — Primary Key
* `name`
* `code`
* `unit_of_measure`
* `description`

### Energy Consumption

* `energy_consumption_id` — Primary Key
* `equipment_id` — Foreign Key
* `energy_source_id` — Foreign Key
* `timestamp`
* `consumption_amount`

### Energy Tariff

* `energy_tariff_id` — Primary Key
* `energy_source_id` — Foreign Key
* `start_date`
* `end_date`
* `price_per_unit`

### Maintenance

* `maintenance_id` — Primary Key
* `equipment_id` — Foreign Key
* `start_time`
* `end_time`
* `type`
* `cost`
* `description`

---

## Main Relationships

```text
Production Unit 1 ──── N Equipment
Production Unit N ──── N Product
Production Unit 1 ──── N Production Record
Product         1 ──── N Production Record

Production Record 1 ──── N Material Consumption
Raw Material     1 ──── N Material Consumption

Equipment      1 ──── N Energy Consumption
Energy Source  1 ──── N Energy Consumption
Energy Source  1 ──── N Energy Tariff

Equipment 1 ──── N Maintenance
```

## Design Notes

* Production and energy consumption are recorded hourly.
* Energy consumption is recorded at the equipment level.
* Production unit energy consumption is calculated from its equipment.
* Energy cost is calculated from consumption and the applicable energy tariff.
* Operating time and downtime are derived from production and maintenance records.
* Inventory management and accounting are outside the project scope.
