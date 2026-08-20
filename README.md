# 📊 Executive Strategic Initiatives & Operational Risk Analytics Platform

[![SQL Server](https://img.shields.io/badge/SQL_Server-SSMS_%7C_T--SQL-CC292B?logo=microsoftsqlserver)](https://github.com/rashmileema-BI)
[![Power BI](https://img.shields.io/badge/Power_BI-Executive_Dashboards-F2C811?logo=powerbi)](https://github.com/rashmileema-BI)
[![ETL](https://img.shields.io/badge/ETL-KPI_Engineering-blue)](https://github.com/rashmileema-BI)

An enterprise-style analytics solution designed to monitor strategic initiatives, operational risks, project performance, and executive KPIs using SQL Server and Power BI. This platform simulates a real-world PMO (Project Management Office) and executive reporting environment.

---

## 🎯 Project Overview

Organizations manage hundreds of strategic initiatives across Finance, IT, Sales, HR, and Operations. Executive leadership requires centralized visibility into:

* Project completion percentages and delivery timelines
* Operational bottlenecks and dependency-related delays
* High-risk initiatives requiring immediate executive escalation
* Departmental efficiency scoring and performance rankings
* Resource constraints and budget variances

---

## 🛠️ Tech Stack

| Tool | Purpose |
| :--- | :--- |
| **SQL Server** | Relational database management, data staging, and schema design |
| **SSMS** | T-SQL ETL transformations, Views, and analytical query development |
| **Power BI** | Multi-page executive dashboard suite and interactive KPI drill-throughs |
| **Mockaroo / Excel** | Synthetic enterprise operational log generation and ingestion |

---

## 📐 Pipeline Architecture & Database Structure

```mermaid
flowchart TD
    A[Mockaroo Raw Data] --> B[Action_Log_Raw Staging]
    B --> C[SQL ETL & Transformation Layer]
    C --> D[Action_Log_Clean Star Schema]
    D --> E[SQL Analytical Queries & Rankings]
    E --> F[Power BI 4-Page Executive Dashboard]
