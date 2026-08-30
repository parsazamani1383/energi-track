# EnergiTrack

### Steel Plant Energy Management Database

EnergiTrack is a PostgreSQL database project designed to manage and analyze energy consumption and production activities in a steel manufacturing plant.

The system focuses on the relationship between **energy consumption, production, equipment, maintenance, and raw materials**. Operational data is recorded at an hourly level to support meaningful analysis and future machine learning applications.

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
* Calculate energy costs and energy efficiency indicators.
* Practice SQL queries and database concepts.
* Prepare structured data for future data analysis and machine learning.

---

## 🏭 System Overview

The system models the main operational aspects of a fictional steel manufacturing plant.

The plant consists of several production units, each containing industrial equipment used in the production process.

The simplified structure is:

```text
Steel Plant
│
├── Production Units
│   ├── Hot Rolling
│   ├── Cold Rolling
│   ├── Galvanizing
│   └── Color Coating
│
├── Products
│   ├── Hot Rolled Sheet
│   ├── Cold Rolled Sheet
│   ├── Galvanized Sheet
│   └── Color-Coated Sheet
│
├── Equipment
│
├── Energy
│   ├── Electricity
│   └── Natural Gas
│
├── Production Records
│
├── Material Consumption
│
└── Maintenance Records
```

---

## ⚙️ Main Features

* Manage production units and products
* Manage industrial equipment
* Record hourly production quantities
* Record hourly energy consumption
* Support multiple energy sources
* Track equipment maintenance and downtime
* Record raw material consumption
* Manage energy tariffs
* Calculate energy costs
* Analyze energy consumption by equipment and production unit
* Calculate energy intensity
* Generate analytical reports using SQL

---

## 📊 Energy Analysis

Energy consumption is recorded at the **equipment level**.

This allows the energy consumption of each production unit to be calculated from the consumption of its equipment without storing duplicate data.

For example:

```text
Hot Rolling
│
├── Furnace       → 5,000 kWh
├── Rolling Mill  → 7,000 kWh
└── Pump          → 1,000 kWh
                    ─────────
                    13,000 kWh
```

The system can be used to calculate indicators such as:

### Energy Intensity

```text
Energy Intensity = Energy Consumption / Production Output
```

### Energy Cost

```text
Energy Cost = Energy Consumption × Energy Tariff
```

These indicators can be analyzed across different equipment, production units, products, and time periods.

---

## ⏱️ Data Granularity

Operational data is designed around **hourly records**.

Examples include:

* Hourly production
* Hourly energy consumption
* Hourly material consumption

Maintenance records use precise start and end timestamps so that equipment downtime can be calculated when required.

Derived values such as operating time and production-unit energy consumption are calculated from the underlying records rather than unnecessarily stored as duplicate data.

---

## 🗄️ Database

### Database Management System

* PostgreSQL

### Main Database Concepts

The project will demonstrate:

* Relational database design
* Entity Relationship Diagram (ERD)
* Normalization
* Primary Keys
* Foreign Keys
* Constraints
* Indexes
* Joins
* Aggregation
* Subqueries
* Common Table Expressions (CTEs)
* Window Functions
* Views
* Transactions

---

## 🧪 Data

The project will use generated and fictional data designed to simulate realistic industrial operations.

The generated data may include:

* Production records
* Energy consumption records
* Equipment information
* Maintenance records
* Raw material consumption
* Production units
* Products
* Energy sources
* Energy tariffs

No real industrial or company data is used.

---

## 🤖 Future Data Analysis & Machine Learning

The database is designed to provide a foundation for future data analysis and machine learning projects.

Possible future applications include:

### Energy Consumption Prediction

Predict future energy consumption based on historical operational data such as:

* Production output
* Energy consumption
* Equipment information
* Operating conditions
* Maintenance history

### Energy Anomaly Detection

Identify unusual energy consumption patterns under similar production conditions.

### Energy Efficiency Analysis

Analyze factors affecting energy consumption and identify production conditions associated with higher or lower energy efficiency.

These applications are **future extensions** and are not part of the initial database implementation.

---

## 📁 Project Structure

The project structure will evolve during development.

The planned structure is:

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

> The actual structure may change as the project develops.

---

## 🚀 Future Improvements

Possible future improvements include:

* Expanding analytical SQL queries
* Generating larger and more realistic datasets
* Creating a data analysis layer using Python and Pandas
* Building a machine learning dataset from the database
* Developing energy consumption prediction models
* Creating data visualizations and analytical dashboards

---

## 📌 Project Status

**Status:** 🚧 In Development

EnergiTrack is being developed as a personal database engineering and data analysis project.

---

## 📄 License

This project is licensed under the **MIT License**.
