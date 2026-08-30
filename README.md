# EnergiTrack

### Steel Plant Energy Management Database

EnergiTrack is a PostgreSQL database project designed to manage, track, and analyze energy consumption in a steel manufacturing plant.

The project models energy consumption alongside production activities, industrial equipment, and maintenance records. The database is designed with future data analysis and machine learning applications in mind.

> **Note:** This is a fictional project inspired by the general structure of steel manufacturing plants. It does not represent the internal systems or actual data of any specific company.

---

## 🎯 Project Goals

The main goals of EnergiTrack are to:

* Design a realistic relational database for an industrial environment.
* Practice database design and PostgreSQL development.
* Track electricity and natural gas consumption.
* Record production activities and output.
* Manage industrial equipment and maintenance records.
* Calculate and analyze energy consumption indicators.
* Practice advanced SQL queries and database concepts.
* Prepare structured data that can later be used for data analysis and machine learning.

---

## 🏭 System Overview

The system focuses on the relationship between **production, equipment, and energy consumption** within a steel manufacturing plant.

The simplified structure of the system is:

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
├── Energy Sources
│   ├── Electricity
│   └── Natural Gas
│
├── Production Records
│
├── Energy Consumption Records
│
└── Maintenance Records
```

---

## ⚙️ Main Features

* Manage production units and products
* Manage industrial equipment
* Record production quantities
* Record energy consumption
* Support multiple energy sources
* Track equipment maintenance
* Analyze energy consumption by production unit
* Calculate energy intensity
* Generate analytical reports using SQL

---

## 📊 Energy Analysis

One of the main purposes of the database is to analyze the relationship between energy consumption and production.

For example, the system can be used to calculate:

**Energy Intensity**

```text
Energy Intensity = Energy Consumption / Production Output
```

This allows the energy performance of different production units and time periods to be compared.

---

## 🗄️ Database

### Database Management System

* PostgreSQL

### Main Database Concepts

The project will cover and demonstrate:

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

The generated data will include information such as:

* Production records
* Energy consumption
* Equipment usage
* Maintenance activities
* Production units
* Energy sources

The data is not intended to represent real operational data from any specific steel manufacturer.

---

## 🤖 Future Machine Learning Applications

The database is designed with future data analysis and machine learning projects in mind.

Possible future applications include:

### Energy Consumption Prediction

Predict future energy consumption based on:

* Production output
* Operating hours
* Equipment information
* Historical energy consumption
* Maintenance history

### Energy Anomaly Detection

Identify unusual energy consumption patterns under similar production conditions.

### Equipment Failure Prediction

Use equipment, maintenance, production, and energy data to investigate the possibility of predicting equipment failures.

These applications are **future extensions** of the project and are not part of the initial database implementation.

---

## 📁 Project Structure

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
│   ├── constraints.sql
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

> The project structure may change as development progresses.

---

## 🚀 Future Improvements

Possible future improvements include:

* Expanding the analytical SQL queries
* Adding more realistic generated data
* Creating a data analysis layer using Python and Pandas
* Building a machine learning dataset from the database
* Developing energy consumption prediction models
* Adding visualization and reporting

---

## 📌 Project Status

**Status:** 🚧 In Development

This project is being developed as a personal database engineering and data analysis project.

---

## 📄 License

This project is licensed under the **MIT License**.
