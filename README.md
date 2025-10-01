# Superstore-Analysis
• Data source: Tableau Sample Superstore

• Tools: SQL (MySQL), Tableau

## Introduction
Superstore is a U.S. based small retail business that sells furniture, office supplies, and technology products. Their customer segments are mass Consumers, Corporate, and Home Offices. The project aims to provide a thorough analysis of Superstore sales performance and trends to reveal key insights that can be used to guide data-driven decision-making. Using a detailed dataset, the project explores multiple facets of the business, including sales trends, product popularity, regional market performance, and more. This report highlights key metrics, analyzes category and product performance, examines regional sales trends, and offers strategic insights and recommendations to optimize sales and maintain a competitive edge in the industry.

## Requirements
The Superset dataset used in this project was obtained from Kaggle and converted from an XSLX file to a CSV file for easier handling. The analysis was performed using MySQL and complemented using Tableau to create an interactive dashboard for data visualization.
The data is publicly available through Kaggle. It comes with 9995 rows with 9994 rows of pure data and 1 row being column headers. It contains the data of 793 customers. The data contains 21 columns namely; Row ID, Order ID, Order Date, Ship Date, Ship Mode, Customer ID , Customer Name, Segment, Postal Code, City, State, Country, Region, Product ID, Category, Sub-Category, Product Name, Sales, Quantity, Discount and Profit.
The only limitations of our dataset that I could mention is that the most recent data point was almost 10 years ago. So our data is not current. However, our data is quite reliable, original, comprehensive and is cited.

## Business Questions
1. What is the yearly total sales and profit?
2. What is the total sales, average sales and percent of total sales of each category?
3. What are the profits by products(sub_category)?
4. What are the sales by products(sub_category)?
5. Which segment makes the most of our sales and profit?

## Data Cleaning and Preparation
### Duplicate Values 
After importing the database and values from the .csv file in the MySQL workbench, I checked for duplicate values. Duplicate values may lead to inaccurate analysis.
There appears to be 0 duplicate entries across all columns.

### Null Values
Checking for null values involves identifying any missing or undefined data in each column.
There were no null values found in the dataset.

### Update Table
Updating the schema to add an "order_year" column by extracting the year from order_date for easier filtering by year.

```
ALTER TABLE sample_superstore
ADD COLUMN order_year INT AFTER order_id;

UPDATE sample_superstore
SET order_year = YEAR(order_date);
```

## Data Analysis & Insights
1. The data below shows how the profits over the years have steadily increased with each year being more profitable than the other.
```
SELECT order_year, SUM(sales) as total_sales, SUM(profit) as total_profit
FROM sample_superstore
GROUP BY 1
ORDER BY 1;
```
| order_year | total_sales | total_profit |
|------------|-------------|--------------|
| 2011       | 481763.83   | 49044.48     | 
| 2012       | 464426.18   | 60907.79     | 
| 2013       | 600533.77   | 80062.50     | 
| 2014       | 733215.19   | 93439.73     | 

2.	Technology is the largest category with total sales of $835.2K, accounting for about 36% of Superstore's total business. The Furniture and Office Supplies categories each account for 32% and 30% of total sales, respectively.
```
SELECT category, SUM(sales) AS total_sales, AVG(sales) AS average_sales,
SUM(sales)/(SELECT SUM(sales) FROM sample_superstore)*100 AS percentage_of_total
FROM sample_superstore
GROUP BY 1
ORDER BY 2 desc;
```
| category        | total_sales | avg_sales  | perc_of_total |
|-----------------|-------------|------------|---------------|
| Technology      | 835900.14   | 454.540587 | 36.784093     |
| Furniture       | 733047.06   | 353.446027 | 32.258005     |
| Office Supplies | 703502.87   | 121.692245 | 30.957902     |

3.	The most profitable subcategory is Copiers generating total profits of $55.6K. The least profitable subcategory is Tables which has a total profit loss of -$17.7K. The Tables subcategory is negatively contributing to Superstore's overall profitability and should be investigated as a potential subcategory to exit if profitability cannot be improved through more favorable cost structures.
```
(
	SELECT subcategory, SUM(profit) AS total_profit
	FROM superstore.orders
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1
)
UNION
(
	SELECT subcategory, SUM(profit) AS total_profit
	FROM superstore.orders
	GROUP BY 1
	ORDER BY 2 ASC
	LIMIT 1
);
```
| subcategory | total_profit |
|-------------|--------------|
| Copiers     |  55617.9     |
| Tables      | -17725.59    |

4. The best selling subcategory is Phones generating total sales of 329k. The least selling subcategory is Fasteners which has a total sales of 3008.63 . The Tables subcategory is negatively contributing to Superstore's overall profitability and should be investigated as a potential subcategory to exit if profitability cannot be improved through more favorable cost structures.
```
(
	SELECT sub_category, SUM(sales) AS total_sales
	FROM sample_superstore
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1
)
UNION
(
	SELECT sub_category, SUM(sales) AS total_sales
	FROM sample_superstore
	GROUP BY 1
	ORDER BY 2 ASC
	LIMIT 1
);
```
| subcategory | total_sales  |
|-------------|--------------|
| Phones      |  329753.14   |
| Fasteners   |  3008.63     |

5.	The most selling and profitable segment is mass Consumers with a total profit of $132.6K, while the least selling and profitable segment is Home Office with $59.8K in profits. Profits in the Consumer segment are about 2.2x that of Home Office; this is a strong indicator that mass Consumers should continue to be a strategic focus for Superstore.
```
SELECT segment, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM sample_superstore
GROUP BY 1
ORDER BY 2 DESC;
```
| segment     | total_sales | total_profit |
|-------------|-------------| ------------ |
| Consumer    | 1150166.18  |  132669.88   |
| Corporate   | 696604.60   |   90366.57   |
| Home Office | 425679.29   |   59822.01   |

5.	The top 3 spending customers are Sean Miller ($25K), Tamara Chand ($19K), and Raymond Buch ($15K). Superstore's Sales & Marketing teams can strengthen customer retention and increase customer lifetime value through personalized marketing campaigns and loyalty programs that reward top spenders with highly desirable incentives. 
```
SELECT *
FROM 
	(SELECT customer_id, customer_name, SUM(sales) AS total_spend,
		DENSE_RANK() OVER(ORDER BY SUM(sales) DESC) AS top_rank_customers
	FROM sample_superstore
	GROUP BY 1, 2) AS t1
WHERE top_rank_customers <= 3;
```
| customer_id | customer_name | total_spend | top_rank_customers |
|-------------|---------------|-------------|--------------------|
| SM-20320    | Sean Miller   | 25043.07    | 1                  |
| TC-20980    | Tamara Chand  | 19017.85    | 2                  |
| RB-19360    | Raymond Buch  | 15117.35    | 3                  |

## Data Visualization
As a complement to this project, I created a Superstore Sales Dashboard in Tableau Public linked here [Superstore Sales Analysis](https://public.tableau.com/shared/DH8Q3559B?:display_count=n&:origin=viz_share_link). This dashboard provides a graphical representation of the key metrics most important to stakeholders at Superstore.
