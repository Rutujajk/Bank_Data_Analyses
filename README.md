The Banking Analytics SQL Project focuses on analyzing banking data using SQL to extract meaningful insights about customers, accounts, transactions, loans, and customer complaints.

This project uses MySQL queries to perform data exploration, filtering, sorting, aggregation, grouping, conditional analysis, and table joins. It demonstrates fundamental SQL skills used in banking operations, business reporting, and data analysis.

🎯 Project Objectives
Analyze customer demographics, income, age, and KYC status.
Examine account balances, account types, and account status.
Analyze transaction amounts, channels, and transaction statuses.
Explore loan information and customer relationships.
Perform aggregations to generate business insights.
Combine multiple tables using SQL JOIN operations.
Categorize customers, account balances, and transactions using CASE statements.
🛠️ Tools & Technologies
Database: MySQL
SQL Tool: MySQL Workbench
Language: SQL
Version Control: Git and GitHub
🗂️ Database Tables

The project uses the following seven tables:

Table Name	Description
branches	Banking branch information
customers	Customer details and demographics
accounts	Account types, balances, and status
transactions	Transaction amounts, channels, and status
loans	Customer loan details
loan_payments	Loan repayment information
complaints	Customer complaints information
📊 SQL Concepts Covered

This project contains 40 numbered SQL queries and additional data exploration queries.

Basic Queries: SELECT, column aliases, DISTINCT
Filtering: WHERE, AND, OR, IN, BETWEEN, comparison operators
Pattern Matching: LIKE
Sorting and Limiting: ORDER BY, LIMIT
Aggregate Functions: COUNT(), SUM(), AVG(), MAX()
Grouping: GROUP BY, HAVING
Joins: INNER JOIN and multi-table JOINs
Conditional Logic: CASE statements
Data Analysis: Customer segmentation, balance analysis, and transaction analysis
🔍 Key Analysis Areas
1. Customer Analysis
Identify customers by city.
Analyze customer age and annual income.
Check KYC verification status.
Count customers across different cities.
Categorize customers into age groups.
2. Account Analysis
Identify active accounts.
Calculate total and average account balances.
Compare balances across account types.
Find accounts with the highest balances.
Categorize accounts based on balance.
3. Transaction Analysis
Identify high-value transactions.
Analyze failed and completed transactions.
Calculate completed transaction value by channel.
Analyze completed debit transactions.
Categorize transactions by status.
4. Loan Analysis
Retrieve loan details along with customer names.
Connect customer information with loan records.
5. Customer and Account Relationships
Combine customer and account details.
Retrieve customer transaction information through multiple table joins.
💻 Sample SQL Queries

1. Find the five highest-income customers

SELECT customer_id, first_name, city, annual_income
FROM customers
ORDER BY annual_income DESC
LIMIT 5;

2. Calculate total account balance by account type

SELECT
    account_type,
    SUM(balance) AS total_balance
FROM accounts
GROUP BY account_type
ORDER BY total_balance DESC;

3. Analyze completed transactions by channel

SELECT
    channel,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_transaction_value
FROM transactions
WHERE status = 'Completed'
GROUP BY channel
ORDER BY total_transaction_value DESC;

4. Display customer names with their account details

SELECT
    c.first_name,
    c.last_name,
    a.account_type,
    a.balance
FROM customers c
INNER JOIN accounts a
    ON c.customer_id = a.customer_id;
📈 Business Value

The queries demonstrate how SQL can support banking analytics by helping analysts:

Understand customer demographics and income distribution.
Monitor account balances and account statuses.
Examine transaction success and failure patterns.
Summarize transaction activity across channels.
Connect customer, account, and loan information for reporting.

These analyses can support operational reporting and data-driven decision-making.

Skills Demonstrated
SQL querying and data exploration
Data filtering and sorting
Aggregation and grouping
Relational database joins
Conditional logic using CASE
Banking data analysis
Business reporting and analytical thinking

👤 Author
Rutuja Jotiba Karate
Aspiring Data Analyst | SQL | Excel | Data Analysis
