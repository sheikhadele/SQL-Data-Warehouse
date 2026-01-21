# SQL-Data-Warehouse 

# Data Warehouse Project (SQL)

## 📌 Project Overview
This project demonstrates the design and implementation of a **SQL-based Data Warehouse**
using a **Bronze–Silver–Gold layered architecture**.  
Data is extracted from multiple source systems (**CRM and ERP**), processed through
an ETL pipeline, and transformed into analytics-ready datasets to support
**exploratory and advanced data analysis**.

The project follows **modern data engineering best practices**, focusing on
data quality, scalability, and clear separation of responsibilities across layers.

---

## 🏗️ Architecture: Bronze – Silver – Gold

### 🥉 Bronze Layer (Raw Data Ingestion)
- Source systems: **CRM & ERP**
- Stores data in **raw, original format**
- No transformations applied
- Purpose:
  - Preserve source data
  - Enable traceability and reprocessing
- Implemented as:
  - Separate `bronze` schema
  - Tables populated via extraction scripts

---

### 🥈 Silver Layer (Cleaned & Transformed Data)
- Data is:
  - Cleaned (null handling, data type corrections)
  - Standardized (naming conventions, formats)
  - Validated (business rules, integrity checks)
  - Deduplicated using window functions
- Purpose:
  - Create reliable, business-ready datasets
- Implemented as:
  - `silver` schema
  - Transformation logic using SQL, CTEs, and joins

---

### 🥇 Gold Layer (Analytics & Business Layer)
- Data is:
  - Integrated across domains
  - Modeled into **Fact and Dimension tables**
- Designed using **Star Schema principles**
- Implemented as:
  - `gold` schema
  - **Views** for reporting and analytics
- Purpose:
  - Support EDA
  - Enable advanced analytical and business queries

---

## 🔄 ETL Process

**Extract**
- Data sourced from CRM and ERP systems
- Loaded into Bronze layer without modification

**Transform**
- Data cleaned, verified, and standardized in Silver layer
- Business logic applied

**Load**
- Integrated datasets loaded into Gold layer as views
- Optimized for analytics and reporting

---

## 🧱 Data Modeling
- **Fact Tables**
  - Store measurable business metrics
- **Dimension Tables**
  - Provide descriptive context (customer, product, time, location, etc.)
- Schema Design:
  - Star Schema for performance and simplicity

---

## 📊 Analytics & Insights
The Gold layer supports:
- Exploratory Data Analysis (EDA) that includes Database Exploration, Dimension Exploration, Date Exploration, Measures Exploration, Magnitude Exploration, Ranking Analysis.
- Advanced analytical SQL queries & Business-focused reporting such as:
  - Change over time (trends)
  - Cumulative analysis
  - Performance Analysis
  - Part to Whole Analysis
  - Data Segmentation
  - Built Business Report 

---

## 🛠️ Tools & Technologies
- **MySQL 8+**
- **SQL**
  - CTEs
  - Window Functions
  - Joins
  - Views
- Data Warehousing Concepts
- ETL Design Patterns
- EDA Exploratory Data Analysis

---
