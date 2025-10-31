# SQL Portfolio

A collection of SQL queries demonstrating data analysis, aggregation, and complex query techniques using PostgreSQL. This portfolio showcases practical SQL skills applied to real-world datasets including flight operations and global population demographics.

## 📊 Datasets

### Flight Data (1999-2008)
- **Source:** U.S. Department of Transportation
- **Records:** 120+ million flight records
- **Scope:** Domestic flights with detailed operational metrics
- **Key Fields:** Delays, cancellations, carriers, routes, timing data

### World Population Data (1970-2021)
- **Source:** United Nations Population Division
- **Records:** 50+ years of demographic data
- **Scope:** Global population statistics by country
- **Key Fields:** Population, birth/death rates, life expectancy, migration

## 🛠️ Technologies Used

- **Database:** PostgreSQL
- **Data Loading:** Python (Pandas, SQLAlchemy, psycopg2)
- **Key SQL Techniques:**
  - Common Table Expressions (CTEs)
  - Window Functions (LAG, LEAD, PARTITION BY)
  - Complex JOINs
  - Aggregations and GROUP BY
  - Subqueries and Correlated Subqueries
  - CASE statements for conditional logic

## 📁 Repository Contents

### 1. [Flight_Data_Queries.sql](link-to-file)
Analytical queries exploring airline performance, delays, and operational efficiency.

**Sample Questions Answered:**
- Which airlines have the best on-time performance?
- What routes are most prone to weather delays?
- How do carrier delays compare across airlines?
- Which day of the week has the highest likelihood of delays for specific routes?

**Key Techniques Demonstrated:**
- CTEs for multi-step analysis
- Window functions (LAG) for year-over-year comparisons
- JOINs with reference tables for enriched reporting
- Moving averages and rolling calculations
- Percentage calculations and ratio analysis

### 2. [World_Population_Queries.sql](link-to-file)
Demographic analysis queries examining population trends, life expectancy, and correlations.

**Sample Questions Answered:**
- Which countries have the highest population density?
- How has life expectancy changed over time?
- What factors correlate with life expectancy?
- What are the population growth trends by region?

**Key Techniques Demonstrated:**
- Correlation analysis using CORR()
- Window functions for running totals and rankings
- Subqueries for complex filtering
- Year-over-year change calculations
- Aggregations with HAVING clauses

### 3. [data_loader.py](link-to-file)
Python script for loading CSV data into PostgreSQL using Pandas and SQLAlchemy.

**Features:**
- Automated bulk data loading from multiple CSV files
- Column name standardization and mapping
- PostgreSQL connection management
- Scalable for large datasets (120M+ records)

## 📈 Featured Query Examples

### Example 1: Year-over-Year On-Time Performance Analysis
```sql
-- Calculates YoY change in on-time arrival rate using window functions
WITH cte AS (
    SELECT year, 
        AVG(CASE WHEN arrdelay > 0 THEN 0 ELSE 1 END) as pct_on_time
    FROM flightdata
    WHERE year BETWEEN 2000 AND 2007 AND uniquecarrier = 'WN'
    GROUP BY year
)
SELECT *, 
    LAG(pct_on_time, 1, pct_on_time) OVER(ORDER BY year) as previous,
    (pct_on_time - LAG(pct_on_time, 1, pct_on_time) OVER(ORDER BY year)) / 
    LAG(pct_on_time, 1, pct_on_time) OVER(ORDER BY year) as yoy_change
FROM cte;
```
**Business Value:** Tracks airline performance trends over time to identify improvements or declining service quality.

### Example 2: Route-Specific Delay Probability
```sql
-- Identifies likelihood of delays by day of week for specific route
WITH cte AS (
    SELECT dayofweek, arrdelay,
        CASE WHEN arrdelay > 0 THEN 1 ELSE 0 END as arrdelay_pct
    FROM flightdata
    WHERE dest = 'IAH' AND origin = 'MCO' AND year = 2007
)
SELECT dayofweek, ROUND(AVG(arrdelay_pct)*100, 2) as avg_delay
FROM cte
GROUP BY dayofweek
ORDER BY AVG(arrdelay_pct) DESC;
```
**Business Value:** Helps travelers choose optimal travel days to minimize delay risk.

### Example 3: Fastest Airline by Route and Year
```sql
-- Determines which airline had the fastest average flight time per year
WITH cte AS (
    SELECT year, uniquecarrier, AVG(actualelapsedtime) as avg_time
    FROM flightdata
    WHERE origin = 'ORD' AND dest = 'LAX'
    GROUP BY year, uniquecarrier
),
cte2 AS (
    SELECT year, uniquecarrier, 
        MIN(avg_time) OVER(PARTITION BY year) as min_avg_time
    FROM cte
)
SELECT cte.year, cte.uniquecarrier, cte.avg_time
FROM cte
JOIN cte2 ON cte.year = cte2.year AND cte.uniquecarrier = cte2.uniquecarrier
WHERE cte.avg_time = cte2.min_avg_time;
```
**Business Value:** Benchmarks airline operational efficiency and route optimization.

### Example 4: Life Expectancy Correlation Analysis
```sql
-- Analyzes correlations between life expectancy and various demographic factors
WITH cte AS (
    SELECT region, 
        CORR(life_expectancy, pop_density) as density_corr, 
        CORR(life_expectancy, pop_sex_ration) as pop_sex_corr,
        CORR(life_expectancy, median_age_years) as median_age_corr,
        CORR(life_expectancy, pop_growth_rate) as pop_growth_corr
    FROM worldpop
    GROUP BY region
)
SELECT 
    AVG(density_corr) as avg_density_corr,
    AVG(pop_sex_corr) as avg_pop_sex_corr,
    AVG(median_age_corr) as avg_median_age_corr,
    AVG(pop_growth_corr) as avg_pop_growth_corr
FROM cte;
```
**Business Value:** Identifies demographic factors most strongly associated with longevity for policy and healthcare planning.

## 🎯 Skills Demonstrated

### Data Analysis
- Trend analysis and time-series calculations
- Statistical aggregations and correlation analysis
- Ratio and percentage calculations
- Performance benchmarking

### SQL Proficiency
- **Advanced Queries:** CTEs, subqueries, correlated subqueries
- **Window Functions:** LAG, LEAD, ROW_NUMBER, PARTITION BY, OVER
- **Joins:** INNER, LEFT, multiple table joins with reference data
- **Aggregations:** GROUP BY, HAVING, COUNT, AVG, SUM, MIN, MAX
- **Conditional Logic:** CASE statements for derived fields

### Data Engineering
- Bulk data loading and ETL processes
- Database schema design and table creation
- Data type conversion and standardization
- Python integration with PostgreSQL

## 🚀 Getting Started

### Prerequisites
```bash
- PostgreSQL 12+
- Python 3.8+
- Required Python packages: pandas, sqlalchemy, psycopg2
```

### Setup
1. Clone this repository
2. Install Python dependencies: `pip install pandas sqlalchemy psycopg2`
3. Create PostgreSQL database
4. Run `data_loader.py` to load datasets (update connection parameters)
5. Execute queries in your preferred SQL client

## 📝 Query Organization

All queries include:
- **Business question** in comments
- **Query logic** with explanatory comments
- **Key techniques** highlighted
- **Expected output** described

## 🔗 Connect

Feel free to explore these queries and reach out with questions or feedback!

- **LinkedIn:** [Patrick Mead](https://linkedin.com/in/patrick-mead-63b177120)
- **Email:** pmead47@gmail.com

---

*This portfolio demonstrates practical SQL skills developed through 7 years of data quality analysis and testing in enterprise environments.*
