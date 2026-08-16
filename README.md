# Walmart Sales Data Analysis (SQL)

## Overview
A SQL-based exploratory analysis of Walmart sales transaction data across three branches, examining product performance, customer behavior, and sales patterns to surface actionable retail insights.

## Dataset
1,000 sales transactions with fields including branch, city, customer type, gender, product line, unit price, quantity, tax, total, date/time, payment method, cost of goods sold (COGS), gross margin, gross income, and customer rating.

## What This Covers

### Data Preparation
- Created the `sales` table with appropriate data types and constraints.
- Engineered new columns to support time-based analysis: `time_of_day` (Morning/Afternoon/Evening), `day_name`, and `month_name`.

### Product Analysis
- Identified the best-selling and highest-revenue product lines.
- Compared average VAT/tax percentage and average customer rating by product line.
- Flagged product lines as "Good" or "Bad" based on whether their average quantity sold exceeds the overall average.

### Customer Analysis
- Compared customer types (Member vs. Normal) and payment methods.
- Analyzed gender distribution overall and by branch.
- Explored whether time of day or day of week affects average customer ratings.

### Sales Analysis
- Broke down total revenue and COGS by month.
- Identified which branch/city generates the most revenue.
- Found which customer type contributes the most revenue and pays the most VAT.
- Examined sales volume by time of day and day of week.

## Repository Structure
- `data/WalmartSalesData.csv` — raw sales transaction dataset
- `sql/SQL_queries.sql` — full set of SQL queries: table creation, data cleaning, feature engineering, and analysis queries organized by topic (Generic, Product, Customer, Sales)
- `README.md` — this file

## Tools Used
- MySQL

## How to Use
1. Clone this repository.
2. Set up a local MySQL database.
3. Run `sql/SQL_queries.sql` to create the database/table, load `data/WalmartSalesData.csv`, and run the analysis queries.
4. Review query results section by section (Generic, Product, Customer, Sales) to explore the insights.

## Key Takeaways
- Evening hours see the highest sales volume.
- Branches A and C received stronger customer ratings than Branch B.
- Ratings are fairly consistent across time of day, suggesting service quality — not timing — drives customer satisfaction.
