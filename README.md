# EnergiTrack

### Steel Plant Energy Management Database

EnergiTrack is a PostgreSQL database project designed to manage and analyze energy consumption and production activities in a fictional steel manufacturing plant.

The system focuses on the relationship between **production units, products, equipment, energy consumption, maintenance, raw materials, and energy tariffs**. Operational data is recorded at an hourly level to support SQL-based analysis and future data analysis and machine learning applications.

> **Note:** This is a fictional project inspired by the general structure of steel manufacturing plants. It does not represent the internal systems or actual data of any specific company.

---

## 🎯 Project Goals

The main goals of EnergiTrack are to:

* Design a realistic relational database for an industrial environment.
* Practice database design and PostgreSQL development.
* Track electricity and natural gas consumption.
* Record hourly production activities and output.
* Manage industrial equipment and maintenance records.
* Track raw material consumption.
* Manage energy tariffs.
* Calculate energy costs and energy efficiency indicators.
* Practice SQL queries and database concepts.
* Prepare structured operational data for future data analysis and machine learning.

---

## 🏭 System Overview

The system models the main operational aspects of a fictional steel manufacturing plant.

The plant consists of multiple production units, each containing industrial equipment used in the production process.

The current database contains **three production units**:

```text
Steel Plant
│
├── Production Units
│   ├── Hot Rolling Unit
│   ├── Galvanizing Unit
│   └── Color Coating Unit
│
├── Products
│   ├── Hot Rolled Sheet
│   ├── Galvanized Sheet
│   └── Color-Coated Sheet
│
├── Equipment
│
├── Energy Sources
│   ├── Electricity
│   └── Natural Gas
│
├── Production Records
│
├── Material Consumption
│
├── Energy Tariffs
│
└── Maintenance Records
```

Each production unit is mapped to its corresponding product through the `production_unit_product` table.

---

## ⚙️ Main Features

* Manage production units and products
* Manage industrial equipment
* Record hourly production quantities
* Record hourly energy consumption
* Support multiple energy sources
* Track equipment maintenance
* Record raw material consumption
* Manage energy tariffs
* Calculate energy costs
* Analyze energy consumption by equipment and production unit
* Calculate energy intensity
* Generate analytical reports using SQL

---

## 📊 Energy Analysis

Energy consumption is recorded at the **equipment level**.

This allows the energy consumption of each production unit to be calculated from the consumption of its equipment without storing duplicate aggregated data.

The database currently tracks two energy sources:

* Electricity (`kWh`)
* Natural Gas (`m3`)

For example:

```text
Hot Rolling Unit
│
├── Reheating Furnace
├── Roughing Mill
├── Finishing Mill
├── Hydraulic Pump
└── Air Compressor
```

Energy consumption can be aggregated from equipment to production units and analyzed by time period.

### Energy Intensity

```text
Energy Intensity = Energy Consumption / Production Output
```

### Energy Cost

```text
Energy Cost = Energy Consumption × Energy Tariff
```

These indicators can be analyzed across equipment, production units, products, and time periods.

---

## ⏱️ Data Granularity

Operational data is designed around **hourly records**.

The current sample dataset covers:

```text
2024-01-01 00:00:00
        ↓
2025-12-31 23:00:00
```

Examples include:

* Hourly production records
* Hourly energy consumption records
* Hourly material consumption records

Maintenance records use precise start and end timestamps, allowing equipment downtime and maintenance impact to be analyzed.

Derived values such as operating time and production-unit energy consumption are calculated from the underlying records rather than unnecessarily stored as duplicate data.

---

## 🗄️ Database

### Database Management System

* PostgreSQL

### Main Tables

The database currently contains the following tables:

```text
production_unit
equipment
product
production_unit_product
production_record
raw_material
material_consumption
energy_source
energy_consumption
energy_tariff
maintenance
```

### Main Database Concepts

The project demonstrates:

* Relational database design
* Entity Relationship Diagram (ERD)
* Normalization
* Primary Keys
* Foreign Keys
* Composite Foreign Keys
* Unique Constraints
* Check Constraints
* Indexes
* Joins
* Aggregation
* Subqueries
* Common Table Expressions (CTEs)
* Window Functions
* Views
* Transactions

---

## 🧪 Sample Data

The project uses generated and fictional data designed to simulate realistic industrial operations.

The current sample dataset contains:

* 3 production units
* 3 products
* 15 equipment records
* 6 raw materials
* 2 energy sources
* 16 energy tariff records
* 184 maintenance records
* 52,632 production records
* 105,264 material consumption records
* 526,320 energy consumption records

The production, material consumption, and energy consumption data are generated at an hourly level for the two-year period from 2024 through 2025.

No real industrial or company data is used.

---

## 🔗 Data Relationships

The main relationships in the database are:

```text
Production Unit
      │
      ├── Equipment
      │      │
      │      ├── Energy Consumption
      │      └── Maintenance
      │
      └── Production Unit / Product
                    │
                    └── Production Record
                              │
                              └── Material Consumption

Energy Source
      ├── Energy Consumption
      └── Energy Tariff
```

The `production_record` table uses a composite foreign key referencing `production_unit_product`. This ensures that production can only be recorded for valid unit-product combinations.

---

## 🔍 Data Validation

The database has been tested after loading the sample dataset.

Current validation checks include:

* Record count validation
* Foreign key integrity
* Orphan record detection
* Duplicate detection
* Negative and invalid value checks
* Timestamp range validation
* Production capacity validation

The validation process is being performed using SQL queries after the sample data has been loaded.

---

## 🤖 Future Data Analysis & Machine Learning

The database provides a foundation for future data analysis and machine learning projects.

Possible future applications include:

### Energy Consumption Prediction

Predict future energy consumption based on historical operational data such as:

* Production output
* Energy consumption
* Equipment information
* Maintenance history
* Time-based operating patterns

### Energy Anomaly Detection

Identify unusual energy consumption patterns under similar production conditions.

### Energy Efficiency Analysis

Analyze factors affecting energy consumption and identify production conditions associated with higher or lower energy efficiency.

These applications are **future extensions** and are not part of the current database implementation.

---

## 📁 Project Structure

The planned project structure is:

```text
EnergiTrack/
│
├── README.md
│
├── docs/
│   ├── requirements.md
│   ├── database-design.md
│   └── erd.png
│
├── database/
│   ├── schema.sql
│   ├── indexes.sql
│   ├── views.sql
│   └── queries.sql
│
├── data/
│   └── sample_data.sql
│
├── scripts/
│   └── generate_data.py
│
└── .gitignore
```

> The actual repository structure may evolve as the project develops.

---

## 🚀 Future Improvements

Possible future improvements include:

* Completing and expanding analytical SQL queries
* Creating database views for frequently used analysis
* Building a data analysis layer using Python and Pandas
* Creating a machine learning dataset from the database
* Developing energy consumption prediction models
* Detecting energy consumption anomalies
* Creating data visualizations and analytical dashboards

---

## 📌 Project Status

**Status:** 🚧 In Development

The database schema and sample dataset have been implemented and successfully loaded into PostgreSQL.

The project is currently progressing through **database validation and analytical SQL development**.

Future stages will focus on analytical queries, views, data analysis, visualization, and potential machine learning applications.

---

## 📄 License

This project is licensed under the **MIT License**.
