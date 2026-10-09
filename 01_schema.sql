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
