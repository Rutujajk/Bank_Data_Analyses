-- Banking Customer & Transaction Analytics
-- Target: MySQL 8.0+
CREATE DATABASE IF NOT EXISTS BankingAnalytics;
USE BankingAnalytics;

DROP TABLE IF EXISTS complaints;
DROP TABLE IF EXISTS loan_payments;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS branches;

CREATE TABLE branches (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(100) NOT NULL,
  city VARCHAR(60) NOT NULL,
  manager_id VARCHAR(20) NOT NULL
);

CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  first_name VARCHAR(60) NOT NULL,
  last_name VARCHAR(60) NOT NULL,
  city VARCHAR(60) NOT NULL,
  age TINYINT UNSIGNED NOT NULL,
  annual_income DECIMAL(12,2) NOT NULL,
  kyc_status ENUM('Verified','Pending','Expired') NOT NULL,
  customer_since DATE NOT NULL,
  CHECK (age BETWEEN 18 AND 100),
  CHECK (annual_income >= 0)
);

CREATE TABLE accounts (
  account_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  branch_id INT NOT NULL,
  account_type ENUM('Savings','Current','Salary','Fixed Deposit') NOT NULL,
  opening_date DATE NOT NULL,
  balance DECIMAL(14,2) NOT NULL DEFAULT 0,
  status ENUM('Active','Dormant','Closed') NOT NULL,
  CONSTRAINT fk_accounts_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  CONSTRAINT fk_accounts_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
  CHECK (balance >= 0)
);

CREATE TABLE transactions (
  transaction_id INT PRIMARY KEY,
  account_id INT NOT NULL,
  transaction_date DATE NOT NULL,
  amount DECIMAL(14,2) NOT NULL,
  transaction_type ENUM('Credit','Debit') NOT NULL,
  channel ENUM('Mobile App','ATM','Branch','Internet Banking','UPI','POS') NOT NULL,
  status ENUM('Completed','Failed','Pending','Reversed') NOT NULL,
  merchant_category ENUM('Groceries','Utilities','Travel','Dining','Shopping','Healthcare','Education','Transfer','Cash') NOT NULL,
  CONSTRAINT fk_transactions_account FOREIGN KEY (account_id) REFERENCES accounts(account_id),
  CHECK (amount > 0),
  INDEX idx_transactions_date_status (transaction_date, status),
  INDEX idx_transactions_account_date (account_id, transaction_date)
);

CREATE TABLE loans (
  loan_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  branch_id INT NOT NULL,
  loan_type ENUM('Personal','Home','Auto','Education','Business') NOT NULL,
  loan_amount DECIMAL(14,2) NOT NULL,
  interest_rate DECIMAL(5,2) NOT NULL,
  disbursement_date DATE NOT NULL,
  loan_status ENUM('Active','Closed','Defaulted','Restructured') NOT NULL,
  CONSTRAINT fk_loans_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  CONSTRAINT fk_loans_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
  CHECK (loan_amount > 0),
  CHECK (interest_rate > 0)
);

CREATE TABLE loan_payments (
  payment_id INT PRIMARY KEY,
  loan_id INT NOT NULL,
  due_date DATE NOT NULL,
  payment_date DATE NULL,
  amount_due DECIMAL(12,2) NOT NULL,
  amount_paid DECIMAL(12,2) NOT NULL DEFAULT 0,
  CONSTRAINT fk_payments_loan FOREIGN KEY (loan_id) REFERENCES loans(loan_id),
  CHECK (amount_due > 0),
  CHECK (amount_paid >= 0),
  INDEX idx_payments_due (due_date, payment_date)
);

CREATE TABLE complaints (
  complaint_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  complaint_date DATE NOT NULL,
  category ENUM('Transaction Failure','Card Issue','Loan Service','Account Access','KYC','Fraud Concern','Service Quality') NOT NULL,
  priority ENUM('Low','Medium','High') NOT NULL,
  resolution_status ENUM('Resolved','Open','In Progress') NOT NULL,
  resolution_date DATE NULL,
  CONSTRAINT fk_complaints_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  INDEX idx_complaints_status_date (resolution_status, complaint_date)
);


USE BankingAnalytics;

SHOW TABLES;

SELECT COUNT(*) FROM branches;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM accounts;
SELECT COUNT(*) FROM transactions;
SELECT COUNT(*) FROM loans;
SELECT COUNT(*) FROM loan_payments;
SELECT COUNT(*) FROM complaints;

/*1. Display selected columns*/
SELECT customer_id, first_name, last_name, city
FROM customers;

/*2. Rename columns using aliases*/
SELECT
    customer_id AS ID,
    first_name AS FirstName,
    city AS CustomerCity
FROM customers;

/*3. Find customers from Pune*/
SELECT *
FROM customers
WHERE city = 'Pune';

/*4. Find customers older than 40 */
SELECT *
FROM customers
WHERE age > 40;

/*5. Find customers earning more than ₹500,000 annually */
SELECT customer_id, first_name, annual_income
FROM customers
WHERE annual_income > 500000;

/*6. Find verified KYC customers */
SELECT *
FROM customers
WHERE kyc_status = 'Verified';

/*7. Find active accounts */
SELECT *
FROM accounts
WHERE status = 'Active';

/*8. Customers aged between 25 and 40 */
SELECT *
FROM customers
WHERE age >= 25 AND age <= 40;

/*9. Customers not from Mumbai */
SELECT *
FROM customers
WHERE city <> 'Mumbai';

/*10. Customers from Pune or Kolhapur */
SELECT *
FROM customers
WHERE city = 'Pune'
   OR city = 'Kolhapur';
   
/*11. Use IN */
SELECT *
FROM customers
WHERE city IN ('Pune', 'Mumbai', 'Kolhapur');

/*12. Find customers with pending or expired KYC */
SELECT *
FROM customers
WHERE kyc_status IN ('Pending', 'Expired');

/*13. Sort customers by age, youngest first */
SELECT *
FROM customers
ORDER BY age ASC;

/*14.Sort customers by income, highest first */
SELECT *
FROM customers
ORDER BY annual_income DESC;

/*15. Show the five highest-income customers */
SELECT customer_id, first_name, city, annual_income
FROM customers
ORDER BY annual_income DESC
LIMIT 5;

/*16.Find customers whose first name starts with A*/
SELECT *
FROM customers
WHERE first_name LIKE 'A%';

/*17. Find names containing 'an' */
SELECT *
FROM customers
WHERE first_name LIKE '%an%';

/*18. Count total customers */
SELECT COUNT(*) AS total_customers
FROM customers;

/*19. Find the highest annual income */
SELECT MAX(annual_income) AS highest_income
FROM customers;

/*20. Find the average customer age */
SELECT ROUND(AVG(age), 2) AS average_age
FROM customers;

/*21. Calculate total account balance */
SELECT SUM(balance) AS total_account_balance
FROM accounts;

/*Calculate average account balance */
SELECT ROUND(AVG(balance), 2) AS average_balance
FROM accounts;

/*23. List all unique cities */
SELECT DISTINCT city
FROM customers;

/*24. Count customers in each city */
SELECT
    city,
    COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

/*25. Count accounts by status */
SELECT
    status,
    COUNT(*) AS account_count
FROM accounts
GROUP BY status;

/*26. Calculate total balance by account type */
SELECT
    account_type,
    SUM(balance) AS total_balance
FROM accounts
GROUP BY account_type
ORDER BY total_balance DESC;

/*27 Calculate completed transaction value by channel */
SELECT
    channel,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_transaction_value
FROM transactions
WHERE status = 'Completed'
GROUP BY channel
ORDER BY total_transaction_value DESC;

/*28. Find cities with more than 15 customers */
SELECT
    city,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city
HAVING COUNT(*) > 15;

/*29. Find account types with total balances above ₹1,000,000 */
SELECT
    account_type,
    SUM(balance) AS total_balance
FROM accounts
GROUP BY account_type
HAVING SUM(balance) > 1000000;

/*30. Find transactions above ₹10,000 */
SELECT *
FROM transactions
WHERE amount > 10000;

/*31. Find failed transactions */
SELECT *
FROM transactions
WHERE status = 'Failed';

/*32. Find completed debit transactions */
SELECT *
FROM transactions
WHERE status = 'Completed'
  AND transaction_type = 'Debit';
  
/*33.Display the 10 largest account balances. */
SELECT * FROM accounts ORDER BY balance DESC LIMIT 10;

/*34. Display customer names with their account details */
SELECT
    c.first_name,
    c.last_name,
    a.account_type,
    a.balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id;
    
/*35. Display customer names with their transactions */
SELECT
    c.first_name,
    c.last_name,
    t.amount,
    t.status
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
JOIN transactions t
    ON a.account_id = t.account_id;
    
/*36.Display loan details with customer names */
SELECT
    c.first_name,
    c.last_name,
    l.loan_type,
    l.loan_amount
FROM customers c
JOIN loans l
    ON c.customer_id = l.customer_id;
    
/*37. Classify customers by age */
SELECT
    first_name,
    age,
    CASE
        WHEN age < 30 THEN 'Young'
        WHEN age < 50 THEN 'Middle-aged'
        ELSE 'Senior'
    END AS age_group
FROM customers;

/*38. Classify account balances */
SELECT
    account_id,
    balance,
    CASE
        WHEN balance < 10000 THEN 'Low Balance'
        WHEN balance < 50000 THEN 'Medium Balance'
        ELSE 'High Balance'
    END AS balance_category
FROM accounts;

/*39. Classify transactions by status */
SELECT
    transaction_id,
    amount,
    status,
    CASE
        WHEN status = 'Completed' THEN 'Successful'
        WHEN status = 'Failed' THEN 'Unsuccessful'
        ELSE 'Other'
    END AS transaction_category
FROM transactions;

/* 40.Display customer names and account types */
SELECT
    c.first_name,
    c.last_name,
    a.account_type
FROM customers c
INNER JOIN accounts a
    ON c.customer_id = a.customer_id;




