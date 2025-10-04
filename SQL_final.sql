create database da_final_project;

update customers
set Gender = NULL
where Gender = '';

update customers
set Age = NULL
where Age = '';

ALTER TABLE Customers MODIFY AGE INT NULL;

create table Transactions
(date_new DATE,
Id_check INT,
ID_client INT,
Count_products DECIMAL(10, 3),
Sum_payment DECIMAL(10, 2)
);


LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\TRANSACTIONS_FINAL.csv"
INTO TABLE Transactions
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from transactions;
select * from Customers;


-- 1. 
SELECT
    c.Id_client,
    c.Gender,
    c.Age,
    ROUND(SUM(t.Sum_payment) / COUNT(t.Id_check), 2) AS avg_check,
    ROUND(SUM(t.Sum_payment) / 12, 2) AS avg_monthly_sum,
    COUNT(t.Id_check) AS total_operations
FROM Customers c
JOIN Transactions t 
    ON c.Id_client = t.ID_client
WHERE t.date_new >= '2015-06-01'
  AND t.date_new < '2016-06-01'
GROUP BY c.Id_client, c.Gender, c.Age
HAVING COUNT(DISTINCT DATE_FORMAT(t.date_new, '%Y-%m')) = 12;


-- 2.
 -- a) Средняя сумма чека в месяц
SELECT
    DATE_FORMAT(date_new, '%Y-%m') AS month,
    ROUND(SUM(Sum_payment) / COUNT(Id_check), 2) AS avg_check_month
FROM Transactions
WHERE date_new >= '2015-06-01'
  AND date_new < '2016-06-01'
GROUP BY DATE_FORMAT(date_new, '%Y-%m')
ORDER BY month;

 -- b) Среднее количество операций в месяц
SELECT
    DATE_FORMAT(date_new, '%Y-%m') AS month,
    COUNT(Id_check) AS ops_month
FROM Transactions
WHERE date_new >= '2015-06-01'
  AND date_new < '2016-06-01'
GROUP BY DATE_FORMAT(date_new, '%Y-%m')
ORDER BY month;

 -- c) Среднее количество клиентов в месяц
SELECT
    DATE_FORMAT(date_new, '%Y-%m') AS month,
    COUNT(DISTINCT ID_client) AS clients_month
FROM Transactions
WHERE date_new >= '2015-06-01'
  AND date_new < '2016-06-01'
GROUP BY DATE_FORMAT(date_new, '%Y-%m')
ORDER BY month;

 -- d) Доля операций и суммы по месяцам
WITH totals AS (
    SELECT
        COUNT(Id_check) AS total_ops,
        SUM(Sum_payment) AS total_sum
    FROM Transactions
    WHERE date_new >= '2015-06-01'
      AND date_new < '2016-06-01'
)
SELECT
    DATE_FORMAT(t.date_new, '%Y-%m') AS month,
    COUNT(t.Id_check) AS ops_month,
    ROUND(COUNT(t.Id_check) / NULLIF(MAX(tt.total_ops),0) * 100, 2) AS ops_share_pct,
    SUM(t.Sum_payment) AS sum_month,
    ROUND(SUM(t.Sum_payment) / NULLIF(MAX(tt.total_sum),0) * 100, 2) AS sum_share_pct
FROM Transactions t
CROSS JOIN totals tt
WHERE t.date_new >= '2015-06-01'
  AND t.date_new < '2016-06-01'
GROUP BY DATE_FORMAT(t.date_new, '%Y-%m')
ORDER BY month;

 -- e) % соотношение M/F/NA и их доля затрат
WITH monthly AS (
    SELECT
        DATE_FORMAT(t.date_new, '%Y-%m') AS month,
        c.Gender,
        t.Id_check,
        t.Sum_payment
    FROM Transactions t
    JOIN Customers c ON t.ID_client = c.Id_client
    WHERE t.date_new >= '2015-06-01'
      AND t.date_new < '2016-06-01'
),
totals AS (
    SELECT
        month,
        COUNT(Id_check) AS ops_month,
        SUM(Sum_payment) AS sum_month
    FROM monthly
    GROUP BY month
)
SELECT
    m.month,
    m.Gender,
    COUNT(m.Id_check) AS ops_gender,
    ROUND(COUNT(m.Id_check) / t.ops_month * 100, 2) AS ops_pct,
    SUM(m.Sum_payment) AS sum_gender,
    ROUND(SUM(m.Sum_payment) / t.sum_month * 100, 2) AS sum_pct
FROM monthly m
JOIN totals t ON m.month = t.month
GROUP BY m.month, m.Gender, t.ops_month, t.sum_month
ORDER BY m.month, m.Gender;


-- 3.

SELECT
    age_group,
    COUNT(t.Id_check) AS total_ops,
    SUM(t.Sum_payment) AS total_sum
FROM Transactions t
JOIN Customers c ON t.ID_client = c.Id_client
CROSS JOIN (
    SELECT
        Id_client,
        CASE
            WHEN Age IS NULL THEN 'NA'
            WHEN Age < 10 THEN '0-9'
            WHEN Age < 20 THEN '10-19'
            WHEN Age < 30 THEN '20-29'
            WHEN Age < 40 THEN '30-39'
            WHEN Age < 50 THEN '40-49'
            WHEN Age < 60 THEN '50-59'
            WHEN Age < 70 THEN '60-69'
            ELSE '70+'
        END AS age_group
    FROM Customers
) g ON g.Id_client = c.Id_client
GROUP BY age_group
ORDER BY age_group;









