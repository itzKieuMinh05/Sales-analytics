# 📊 Sales Analytics — Data Warehouse & Decision Support System

> A complete end-to-end sales analytics pipeline built on a star-schema Data Warehouse, featuring interactive dashboards and advanced data mining algorithms.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Data Architecture](#data-architecture)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Modules](#modules)
  - [Data Visualization](#1-data-visualization)
  - [Data Mining](#2-data-mining)
  - [Decision Support System (DSS)](#3-decision-support-system-dss)
- [Dataset](#dataset)
- [Contributors](#contributors)

---

## Overview

**Sales Analytics** is an academic data analytics project that builds a full pipeline from raw transactional data to business insights. The project implements a classic **star-schema Data Warehouse**, exposes it through a **Dockerized PostgreSQL + Jupyter** environment, and applies four machine learning techniques to extract actionable patterns from ~800,000 sales records.

Key outcomes:
- Centralized, query-ready Data Warehouse with 4 normalized tables
- Interactive Power BI dashboard for executive-level reporting
- Market Basket Analysis to uncover cross-selling opportunities
- Customer segmentation via RFM modelling (K-Means & DBSCAN)

---

## Project Structure

```
Sales-analytics-main/
│
├── data/                               # Preprocessed dimension & fact tables (CSV)
│   ├── dim_customer.csv                # 5,952 customers
│   ├── dim_product.csv                 # 5,241 products
│   ├── dim_time.csv                    # 41,433 time records
│   └── fact_sales.csv                  # 797,815 sales transactions
│
├── script/
│   ├── data_visualization/             # Jupyter notebook + Docker environment
│   │   ├── docker-compose.yml          # PostgreSQL 15 + Jupyter Lab setup
│   │   ├── init/
│   │   │   └── init.sql                # DDL + COPY statements to seed the DB
│   │   └── visualization.ipynb         # Exploratory data analysis & charts
│   │
│   ├── data_mining/                    # Machine learning notebooks
│   │   ├── Data_Mining_Apriori.ipynb   # Association rules — Apriori algorithm
│   │   ├── Data_Mining_FP-Growth.ipynb # Association rules — FP-Growth algorithm
│   │   ├── Data_Mining_K-Means.ipynb   # Customer segmentation — K-Means (RFM)
│   │   └── Data_Mining_DBSCAN.ipynb    # Customer segmentation — DBSCAN (RFM)
│   │
│   └── DSS/                            # Decision Support System
│       ├── Minh.pbix                   # Power BI report file
│       ├── Dashboad 1.png              # Dashboard screenshot — Sales overview
│       └── Dashboad 2.png              # Dashboard screenshot — Product analysis
│
└── DW & DSS Slide (1).pdf             # Project presentation slides
```

---

## Data Architecture

The warehouse follows a **Star Schema** design optimized for analytical queries:

```
                        ┌─────────────────┐
                        │   dim_customer  │
                        │─────────────────│
                        │ customer_key PK │
                        │ customer_id     │
                        │ country         │
                        └────────┬────────┘
                                 │
┌─────────────────┐    ┌─────────▼────────┐    ┌─────────────────┐
│   dim_product   │    │   fact_sales     │    │   dim_time      │
│─────────────────│    │──────────────────│    │─────────────────│
│ product_key  PK │───>│ invoice          │<───│ date_key     PK │
│ stockcode       │    │ customer_key  FK │    │ invoicedate     │
│ description     │    │ product_key   FK │    │ year            │
└─────────────────┘    │ date_key      FK │    │ month           │
                       │ quantity         │    │ day             │
                       │ price            │    │ hour            │
                       │ total            │    │ weekday         │
                       │ is_return        │    └─────────────────┘
                       └──────────────────┘
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Database** | PostgreSQL 15 |
| **Containerization** | Docker & Docker Compose |
| **Notebook Environment** | Jupyter Lab (scipy-notebook) |
| **Data Processing** | Python, Pandas, NumPy |
| **Machine Learning** | scikit-learn, mlxtend |
| **Visualization (EDA)** | Matplotlib, Seaborn |
| **BI Dashboard** | Microsoft Power BI |

---

## Getting Started

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- Python 3.8+ (for running notebooks outside Docker)

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/Sales-analytics.git
cd Sales-analytics
```

### 2. Copy data files into the Docker volume directory

```bash
cp data/*.csv script/data_visualization/warehouse/
```

### 3. Start the Docker environment

```bash
cd script/data_visualization
docker-compose up -d
```

This spins up two services:
- **PostgreSQL** on `localhost:5432` — database `warehouse_db`
- **Jupyter Lab** on `localhost:8888` — access token: `matkhau123`

### 4. Verify the database

The `init.sql` script runs automatically on first start and imports all CSV data. You can verify via:

```bash
docker exec -it warehouse_postgres psql -U warehouse_user -d warehouse_db -c "\dt"
```

### 5. Open Jupyter Lab

Navigate to [http://localhost:8888](http://localhost:8888) and enter the token `matkhau123`.

All notebooks are under `/home/jovyan/work/`.

---

## Modules

### 1. Data Visualization

**File:** `script/data_visualization/visualization.ipynb`

Performs exploratory analysis on the full sales dataset. Key charts produced:

| Analysis | Chart Type |
|---|---|
| Top 10 Countries by Revenue | Horizontal Bar |
| Monthly Sales Trend | Line Chart |
| Top 10 Best-Selling Products | Horizontal Bar |
| Sales Distribution by Hour of Day | Bar Chart |

**Database connection string used in notebooks:**
```
postgresql://warehouse_user:warehouse_pass@postgres:5432/warehouse_db
```

---

### 2. Data Mining

Four algorithms are implemented, each in a self-contained Jupyter notebook.

#### 🛒 Market Basket Analysis

Both algorithms extract **association rules** from invoice-level transaction data to identify which products are frequently purchased together.

| Notebook | Algorithm | Key Parameters |
|---|---|---|
| `Data_Mining_Apriori.ipynb` | Apriori | `min_support=0.02`, `metric="lift"`, `min_threshold=1` |
| `Data_Mining_FP-Growth.ipynb` | FP-Growth | Same parameters, faster on large datasets |

**Output:** Rules in the form `{Product A} → {Product B}` with `support`, `confidence`, and `lift` scores.

#### 👥 Customer Segmentation (RFM)

Both clustering notebooks build an **RFM (Recency, Frequency, Monetary)** feature matrix per customer before applying clustering. Data is log-transformed and standardized before model training.

| Notebook | Algorithm | Notes |
|---|---|---|
| `Data_Mining_K-Means.ipynb` | K-Means | Elbow method used to select optimal K |
| `Data_Mining_DBSCAN.ipynb` | DBSCAN | k-distance graph used to tune `eps` |

**RFM Query (shared across both notebooks):**
```sql
SELECT
    c.customer_id,
    EXTRACT(DAY FROM (SELECT MAX(invoicedate) + INTERVAL '1 day' FROM dim_time)
            - MAX(d.invoicedate))  AS recency,
    COUNT(DISTINCT CASE WHEN f.total > 0 THEN f.invoice END) AS frequency,
    SUM(f.total)                                              AS monetary
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
JOIN dim_time     d ON f.date_key     = d.date_key
WHERE c.customer_id IS NOT NULL
GROUP BY c.customer_id
HAVING SUM(f.total) > 0;
```

---

### 3. Decision Support System (DSS)

**File:** `script/DSS/Minh.pbix`

A Power BI report providing executive dashboards. Two dashboard views are included (screenshots below):

- **Dashboard 1** — Overall sales performance, revenue by country/period
- **Dashboard 2** — Product-level analysis and return rates

> Open `Minh.pbix` in [Power BI Desktop](https://powerbi.microsoft.com/desktop/) to explore the full interactive report.

---

## Dataset

The source data is a retail transaction dataset (similar in structure to the [UCI Online Retail dataset](https://archive.ics.uci.edu/ml/datasets/Online+Retail+II)) covering the period **December 2009 – December 2011**.

| Table | Records | Description |
|---|---|---|
| `fact_sales` | 797,815 | Invoice-level transactions (purchases & returns) |
| `dim_time` | 41,433 | Timestamps broken down to hour granularity |
| `dim_customer` | 5,952 | Unique customers with country |
| `dim_product` | 5,241 | Products with stock code and description |

**Notes:**
- Transactions with `is_return = TRUE` represent customer returns (negative totals).
- Records with `NULL` `customer_id` are guest/anonymous transactions.
- Postage-related line items (`Postage`, `Dotcom Postage`) are excluded from mining analyses.

---



> **Academic project** — built for the Data Warehouse & Decision Support Systems course.
