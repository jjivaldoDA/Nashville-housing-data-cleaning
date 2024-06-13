-- Exploration des données
SELECT * FROM accounts;
SELECT * FROM products;
SELECT * FROM sales_pipeline;
SELECT * FROM sales_teams;

-- Qualité des données
-- Reperer des valeurs nulls
SELECT 
COUNT(*) as NB_rows,
COUNT(*) - COUNT(account) as NUll_account,
COUNT(*) - COUNT(sector) as NUll_sector,
COUNT(*) - COUNT(year_established) as NUll_year_established,
COUNT(*) - COUNT(revenue) as NUll_revenue,
COUNT(*) - COUNT(employees) as NUll_employees,
COUNT(*) - COUNT(office_location) as NUll_location,
COUNT(*) - COUNT(subsidiary_of) as NUll_subsidiary
FROM accounts;

SELECT * FROM accounts WHERE subsidiary_of = '';
-- Remplacer les valeurs Blank dans la colonne subsidiary
UPDATE accounts SET subsidiary_of = 'NONE' WHERE subsidiary_of = '';





