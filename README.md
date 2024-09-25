# Amazon-Revenue-Analysis

## Introduction

Amazon has been facing a notable decline in overall profitability and market competitiveness, with the underlying causes remaining unclear. To address this issue, I conducted a comprehensive analysis of over 20,000 sales records from an Amazon-like e-commerce platform, focusing on sales performance and product profitability. By tackling various **SQL challenges**, such as revenue analysis and product performance, and integrating these insights into a **Power BI dashboard**, I aimed to uncover actionable insights that can help the company regain its profitability and competitive edge.

---

## Business Requirement:

- **Revenue Trend Analysis:** By analyzing sales performance, the company can identify which products or categories are underperforming, understand sales trends, and adjust marketing or product strategies to boost sales.
- **Product Profitability Issues:** Focusing on product performance allows the company to identify which products are not meeting financial expectations

---

## Process Outline

An ERD diagram is included to visually represent the database schema and relationships between tables.

![]()

### 1. **Exploratory Analysis**

The purpose of this exploratory data analysis (EDA) is to understand the different order statuses within the dataset and examine the details associated with each status. This involves investigating orders that have been completed, are in progress, have been returned, or were canceled.

- Identification of Order Statuses:
  - The analysis started by identifying the distinct order statuses in the dataset (Completed, Inprogress, Returned, Cancelled).
- Detailed Examination of Each Status:
  - Completed Orders:
    - Example: Order ID 1
    - This order was placed, paid for, and successfully delivered. This provides a baseline for what a successful transaction looks like, showing no issues in payment, shipping, or return processes.
  - In-progress Orders:
    - Example: Order ID 15
    - This order is still in progress, with payment completed but the order is yet to be fully delivered. This could indicate potential delays or issues in the shipping process, which might contribute to customer dissatisfaction.
  - Returned Orders:
    - Example: Order ID 13
    - This order was placed and shipped, but it was returned, and a refund was issued. Understanding why returns occur is critical, as high return rates can indicate product quality issues, incorrect product descriptions, or customer dissatisfaction.
  - Cancelled Orders:
    - Example: Order ID 2
    - This order was canceled due to payment failure, and no shipping occurred. High cancellation rates could signal issues with the payment process, such as technical problems or customer hesitance at the payment stage.
- Result:
  - Completed orders and In-progress orders are defined as “Successful Sales” and total Revenue is defined as “Revenue”, since the payment is completed
  - Total Revenue in Returned orders are defined as “Return Loss Revenue”, since refund happened
  - Cancelled Orders rate in the past year should be analyzed

### 2. **Success Sales Revenue Analysis for current month (July 2024)**

- Questions
  - What is the total revenue?
  - What is the MoM percentage change in total revenue?
  - What is the YoY percentage change in total revenue?
  - What is the monthly trend of total revenue between August 2023 and July 2024?
- Result
  - Current Month Revenue is **41K** and increase **30%** compare to last month, but decrease **94%** compare to last year.
  - Two big Revenue decline in last recent year, let's look at the most recent one: starting in **January** and ending in **March.**

### 3. **Product Performance Analysis from January to March**

- Questions
  - Contribution to Revenue Decline by Category
  - Identifying Specific Products Contributing to Revenue Decline in Electronics
- Results
  - 99.8% of decline is due to **electronics** revenue decline
  - sales decline in **Apple iMac Pro**, **Apple iMac 27-Inch Retina**, **Apple iPad Air (5th Gen)**, **Apple MacBook Air M2**, **Apple MacBook Pro 16-inch (2021)** contribute to 67.5% decline in electronics.

### 4. **Return Loss Sales Analysis**

- Questions
  - What is the trend of Returned Loss Ratio (Returned Loss Revenue/ Revenue)?
  - Why is the ratio decrease in March?
    - Returned loss revenue decrease more than revenue?
    - Which shipping provider contribute more in returned loss revenue decrease
- Results
  - Returned Loss Ratio drop in **March**
  - Mainly because Returned loss revenue decrease more than revenue and provider “**Bluedart**” contribute ﻿**81.52﻿%** in overall Return Loss Revenue decrease

### 5. **Cancelled rate analysis**

- Questions
  - What is the trend of cancelled rate in the recent year?
- Results
  - There is **no difference** in cancelled rate in first decline and second decline

### 6. **Revenue Analysis Dashboard**

![]()

---

## **Conclusion**

### **Key Findings:**

The analysis highlighted a significant revenue decline from January to March 2024, primarily driven by underperformance in the Electronics category, with five specific Apple products contributing 67.54% to the decline. Additionally, a notable reduction in return loss revenue was observed in March, with the shipping provider Bluedart playing a significant role, contributing 81.52% to the overall decrease. However, July 2024 showed a positive trend with a 30% increase in revenue compared to the previous month, though revenue remained down 94% year-over-year.

### **Next Steps:**

To address the revenue decline and improve profitability, targeted promotions for the underperforming Apple products within the Electronics category are recommended. Strengthening partnerships with Bluedart and other key shipping providers can help further reduce return loss revenue. Additionally, the company should closely monitor order statuses, focusing on returned and canceled orders, to identify and rectify any systemic issues that may be contributing to customer dissatisfaction or operational inefficiencies.

---

## **Learning Outcome**

In writing this SQL script, I honed my skills in advanced SQL techniques, including using GROUP BY and SUM for data aggregation and applying CASE WHEN for categorizing data. I effectively utilized window functions like LAG and LEAD to calculate Month-over-Month (MoM) and Year-over-Year (YoY) changes. By using Common Table Expressions (CTEs) with WITH clauses, I organized complex queries for better readability. Additionally, I analyzed trends and identified key contributors to revenue changes, showcasing my ability to handle complex joins and manage null values, ensuring accurate and insightful data analysis.

In creating this dashboard, I learned to select and format charts effectively, focusing on clear, data-driven storytelling. I prioritized consistent formatting to reduce noise and avoided common errors like wrong chart types, overloading visuals with too many data series, and inconsistent colors. I added context to highlight trends and make meaningful comparisons across time periods. Additionally, I paid close attention to the layout, using reading patterns and visual principles to guide the viewer’s attention.
