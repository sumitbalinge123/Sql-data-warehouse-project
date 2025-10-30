# 🧠 SQL Data Warehouse Project

### **Building a Modern Data Warehouse with SQL Server | ETL | Data Modeling | Analytics**

---

## 🚀 Overview

Hi, I’m **Sumit Balinge**, and this is my **Data Warehouse and Analytics Project** — a complete **end-to-end data engineering and analytics solution** that I built under the guidance of **[Data With Baraa](https://www.youtube.com/@DataWithBaraa)**.

This project demonstrates how raw business data from multiple source systems can be efficiently **processed, cleaned, modeled, and analyzed** to deliver actionable insights and support **data-driven decision-making**.

---

## 🎯 Project Objectives

Through this project, I focused on:

1️⃣ **Building a scalable Data Architecture** following the **Medallion Architecture (Bronze, Silver, Gold)**.  
2️⃣ **Developing ETL Pipelines** to extract, clean, and load data from multiple CSV files into **SQL Server**.  
3️⃣ **Designing Fact and Dimension Tables** using a **Star Schema** model for optimized analytical queries.  
4️⃣ **Performing SQL-based Analytics** to generate insights on:  
   - Customer Behavior  
   - Product Performance  
   - Sales Trends  

This project helped me strengthen my skills in **SQL Development**, **Data Modeling**, **ETL Design**, and **Analytical Reporting**, while applying **industry best practices** in **Data Engineering**.

---

## 🏗️ Data Architecture

The architecture follows the **Medallion Architecture** pattern consisting of three structured layers:

| Layer | Description |
|:------|:-------------|
| 🥉 **Bronze Layer** | Stores **raw data as-is** from the source systems. Data is ingested from **CSV files** into SQL Server. |
| 🥈 **Silver Layer** | Performs **data cleansing, standardization, and normalization** to prepare for analysis. |
| 🥇 **Gold Layer** | Contains **business-ready data** modeled into a **Star Schema** for reporting and analytics. |

---

## 📂 **Repository Structure**  

```

data-warehouse-project/
├── datasets/             # Raw data from ERP and CRM systems.
│
├── docs/                 # Project documentation, architecture diagrams, and outputs.
│   ├── bronze/
│   │   ├── data_flow_bronze.drawio   # Data flow diagram: Source -> Bronze (Draw.io).
│   │   ├── bronze_data_schema.md # Schema of the bronze layer tables.
│   │   └── bronze_output_examples/ # Example of the data after the bronze layer processing.
│   ├── silver/
│   │   ├── data_cleaning_output/   # Examples of data after cleaning.
│   │   ├── data_flow_silver.drawio   # Data flow diagram: Bronze -> Silver (Draw.io).
│   │   ├── Data_Integration.drawio   # Data integration diagram (Draw.io).
│   │   └── silver_data_schema.md # Schema of the silver layer tables.
│   ├── gold/
│   │   ├── output/             # Examples of the data after the gold layer processing.
│   │   ├── data_catalog.md     # Data dictionary for the Gold layer, including field descriptions.
│   │   ├── data_flow_gold.drawio   # Data flow diagram: Silver -> Gold (Draw.io).
│   │   ├── data_models.drawio   # Star schema diagram (Draw.io).
│   │   └── gold_data_schema.md  # Schema of the gold layer tables.
│   └── warehouse/
│       ├── naming_conventions.md # Naming conventions for tables, columns, etc.
│       ├── data_architecture.drawio # Overall data warehouse architecture diagram (Draw.io).
│       └── etl.drawio         # ETL process diagram, showcasing techniques and methods (Draw.io).
│
├── scripts/              # SQL scripts for ETL and transformations.
│   ├── bronze/
│   │   └── load_raw_data.sql # Scripts to load data from the 'datasets' directory into the bronze layer.
│   ├── silver/
│   │   └── transform_clean_data.sql # Scripts to clean and transform the data in the bronze layer.
│   └── gold/
│       ├── create_analytical_views.sql # Scripts to create views for analysis in the gold layer.
│       └── populate_dimensions.sql # Scripts to populate dimension tables.
│   └── init_database.sql   # Script to create the database and schemas.
│
├── tests/                 # Test scripts and quality control files (e.g., data quality checks).
│   └── data_quality_checks.sql # SQL scripts for data quality checks.
│
├── report/                # Analysis scripts and reports.
│   ├── 1_gold_layer_datasets/   # Datasets used for reporting and analysis.
│   ├── 2_eda_scripts/        # Exploratory Data Analysis (EDA) scripts.
│   │   └── basic_eda.ipynb # Jupyter notebook containing basic EDA.
│   ├── 3_advanced_eda/       # Advanced EDA scripts and analyses.
│   │   └── advanced_eda.ipynb # Jupyter notebook containing advanced EDA.
│   ├── output/             # Output from the analysis (e.g., charts, tables).
│   ├── 12_report_customers.sql # SQL script for the customer report.
│   └── 13_report_products.sql # SQL script for the product report.
│
├── README.md              # Project overview, instructions, and report summaries.
├── LICENSE                # License information.
└── requirements.txt        # Project dependencies (e.g.pgsql libraries).
```  


## 📖 Project Components

This project includes the following core components:

1. **Data Architecture:** Designing a modern data warehouse using **Medallion Layers (Bronze, Silver, Gold)**.  
2. **ETL Pipelines:** Implementing SQL scripts for **Extract, Transform, and Load** processes.  
3. **Data Modeling:** Creating **Fact** and **Dimension** tables for analytical queries.  
4. **Analytics & Reporting:** Using SQL to create **reports and dashboards** for business insights.  

📘 **Notion Project Dashboard:**  
[Access All Project Phases & Tasks →](https://www.notion.so/SQL-Data-Warehouse-Project-299669f591ad80fdb350eda1b131af36?source=copy_link)

---

## ⚙️ Project Requirements

### 🧩 Building the Data Warehouse (Data Engineering)

**Objective:**  
Develop a modern **Data Warehouse** using **SQL Server** to consolidate sales data for analytical reporting and business decision-making.

**Specifications:**
- **Data Sources:** Import data from two source systems — **ERP** and **CRM** (CSV files).  
- **Data Quality:** Cleanse and resolve inconsistencies before analysis.  
- **Integration:** Combine both sources into a single, user-friendly **data model**.  
- **Scope:** Focus on the latest dataset only (no historization).  
- **Documentation:** Provide clear documentation for business and analytics teams.

---

### 📊 BI: Analytics & Reporting (Data Analysis)

**Objective:**  
Develop SQL-based analytics to uncover key insights into:

- 🧍 Customer Behavior  
- 📦 Product Performance  
- 💰 Sales Trends  

These insights empower stakeholders with **key business metrics** for **strategic decision-making**.

---

## 🧰 Tech Stack & Tools Used

| Category | Tools / Technologies |
|-----------|----------------------|
| **Database** | SQL Server Express |
| **Interface** | SQL Server Management Studio (SSMS) |
| **ETL / Scripting** | SQL |
| **Data Visualization** | Power BI / Tableau (optional) |
| **Architecture Design** | Draw.io |
| **Documentation** | Notion |
| **Version Control** | Git & GitHub |

---


## 🙏 Acknowledgement

This project was created under the guidance of **[Data With Baraa (Baraa Khatib Salkini)](https://www.youtube.com/@DataWithBaraa)**.

I’m deeply thankful for his **excellent tutorials**, **mentorship**, and **free resources** that made this project possible. His structured approach to **Data Warehousing and Analytics** inspired me to implement industry-level best practices and gain real-world experience.

> 💬 *"Thank you, Baraa, for empowering data professionals and making learning truly impactful!"*

---

## 📬 Connect With Me

Let’s connect and discuss Data Engineering & Analytics!  

- 💼 **LinkedIn:** https://www.linkedin.com/in/sumitbalinge123/  
- 🧑‍💻 **GitHub:** https://github.com/sumitbalinge123 
- 📧 **Email:** sumit.balinge1@email.com  

---

⭐ **If you liked this project, please give it a star on GitHub!** 🌟  
It motivates me to keep learning and sharing more projects.




























