-- Purpose: Classify customers as 'Churned' or 'Active' and analyze churn among high-salary customers.
-- Context: SQL practice using a CTE and CASE expression to derive a churn status flag.
-- Skills: Common Table Expressions (CTEs), CASE expressions, LEFT JOIN, subqueries, aggregation.

WITH customer_status AS (
    -- Build a customer-level table with churn status
    SELECT
        c.customerid,
        c.age,
        c.tenure,
        c.estimatedsalary,
        CASE
            WHEN ch.customerid IS NOT NULL THEN 'Churned'
            ELSE 'Active'
        END AS status
    FROM customers AS c
    LEFT JOIN churn AS ch
        ON c.customerid = ch.customerid
),

high_salary_customers AS (
    -- Keep only customers above a salary threshold
    SELECT
        customerid,
        age,
        tenure,
        estimatedsalary,
        status
    FROM customer_status
    WHERE estimatedsalary > 175000
)

-- Example 1: Row-level view of high-salary customers with churn status
SELECT
    customerid,
    age,
    tenure,
    estimatedsalary,
    status
FROM high_salary_customers
ORDER BY estimatedsalary DESC;

-- Example 2: Aggregated churn breakdown among high-salary customers
SELECT
    status,
    COUNT(*) AS customer_count
FROM high_salary_customers
GROUP BY status
ORDER BY customer_count DESC;