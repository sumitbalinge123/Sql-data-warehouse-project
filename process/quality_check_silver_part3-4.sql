PRINT '===========================================';
PRINT 'bronze.crm_cust_info';
PRINT '===========================================';

-- 1ST STEP

-- check for nulls or duplicates in primary key
-- Expectation : No Result

Select
cst_id,
COUNT(*)
from bronze.crm_cust_info
group by cst_id
Having Count(*) > 1 OR cst_id IS NULL

SELECT
*
from bronze.crm_cust_info
where cst_id = 29466

--2ND STEP

SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
from bronze.crm_cust_info
where cst_id = 29466

--3rd step

SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
from bronze.crm_cust_info

--4th step

SELECT
*
FROM (
SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
from bronze.crm_cust_info
)t WHERE flag_last = 1

--5th step
--QUALITY CHECK : check for unwanted spaces in string values
--Expectation : No Results

select cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)
-- if the original value is not equal to the same value after trimming, it means there are spaces!

select cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr)

--6th step

SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
cst_material_status,
cst_gndr,
cst_create_date
FROM (
	SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	from bronze.crm_cust_info
)t WHERE flag_last = 1

--7th step
-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info
-- in our data warehouse, we aim to store clear and meaningful values rather than using abbreviated terms

-- 8th step
-- APPLY UPPER() just in case mixed-case values appear later in your column
-- APPLY TRIM() just in case spaces appear later in your column
-- IN OUR DATA WAREHOUSE, WE USE THE DEFAULT VALUE 'N/A' FOR MISSING VALUES!


PRINT '>>Truncating Table: silver.crm_cust_info';
TRUNCATE TABLE silver.crm_cust_info;
PRINT '>>Inserting data into: silver.crm_cust_info';

INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_material_status,
	cst_gndr,
	cst_create_date
)
SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'        
	 WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'          
	 ELSE 'n/a'
END cst_material_status,

CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'        
	 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'          
	 ELSE 'n/a'
END cst_gndr,
cst_create_date
FROM (
	SELECT
	*,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	from bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
)r WHERE flag_last = 1

PRINT '===========================================';
PRINT 'bronze.crm_prd_inf';
PRINT '===========================================';

-- check for nulls or duplicates in primary key
-- Expectation : No Result

Select
prd_id,
COUNT(*)
from bronze.crm_prd_info
group by prd_id
Having Count(*) > 1 OR prd_id IS NULL


SELECT prd_id 
      , prd_key ,
	  REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') AS cat_id,
	  SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
       prd_nm 
      , prd_cost 
      , prd_line 
      , prd_start_dt 
      , prd_end_dt 
 FROM  bronze.crm_prd_info 

--filter out unmatched data after applying transformation
SELECT prd_id 
      , prd_key ,
	  REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') AS cat_id,
       prd_nm 
      , prd_cost 
      , prd_line 
      , prd_start_dt 
      , prd_end_dt 
 FROM  bronze.crm_prd_info
 where REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') NOT IN
 (SELECT distinct id from bronze.erp_px_cat_g1v2)

-- Check for NULLS OR NEGATIVE Numbers
--EXPECTATIONS : No Results
SELECT 
    prd_cost 
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency
SELECT DISTINCT 
    prd_line 
FROM bronze.crm_prd_info;

-- Check for Invalid Date Orders (Start Date > End Date)
-- Expectation: No Results
SELECT 
    * 
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

select *
from silver.crm_prd_info


PRINT '===========================================';
PRINT 'bronze.crm_sales_details';
PRINT '===========================================';

select
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details

--negative numbers or zeros can't be cast to a date
--check for invalid dates
select
sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <=0

--nullif() returns null if two given values are equal; otherwise,it returns the first expression
select
NULLIF(sls_order_dt,0) sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <=0 
	or LEN(sls_order_dt) != 8
	or sls_order_dt > 20500101 
	or sls_order_dt < 19000101
	

--in this scenario, the length of the date must be 8
-- check for outliers by validating the boundaries of the date range (sls_order_dt > 20500101 or sls_order_dt < 19000101 )

--CHECK FOR INVALID DATE ORDERS
--order date must always be earlier than the shipping date or due date
select 
*
from bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

--BUSINESS RULES : Sales = Quantity*Price
--               : no negative, nulls, zeros are not allowed
select distinct
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales is null or sls_quantity is null or sls_price is null
OR sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales,
sls_quantity,
sls_price
--discuss this issue with senior
--solution : data issues will be fixed direct in source system
--         : data issues has to be fixed in data warehouse 
--RULES : if sales is negative, zero or null derive it using quantity and price
--      : if price is zero or null, calculate it using sales and quantity
--      : if price is negative, convert it to a positive value
select distinct
sls_sales as old_sls_sales,
sls_quantity,
sls_price as old_sls_price,
CASE WHEN sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price)
		THEN sls_quantity * abs(sls_price)
	ELSE sls_sales
END AS sls_sales,
CASE WHEN SLS_price is null or sls_price <= 0 
		THEN sls_sales / nullif(sls_quantity,0)
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales is null or sls_quantity is null or sls_price is null
OR sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales,sls_quantity,sls_price




select
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
END AS sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
END AS sls_ship_dt,
CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
END AS sls_due_dt,
CASE WHEN SLS_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price)
		THEN sls_quantity * abs(sls_price)
	ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE WHEN SLS_price is null or sls_price <= 0 
		THEN sls_sales / nullif(sls_quantity,0)
	ELSE sls_price
END AS sls_price
from bronze.crm_sales_details



PRINT '>>Truncating Table: silver.crm_sales_details';
TRUNCATE TABLE silver.crm_sales_details;
PRINT '>>Inserting data into: silver.crm_sales_details';


INSERT INTO silver.crm_sales_details (
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)
select
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
END AS sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
END AS sls_ship_dt,
CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
END AS sls_due_dt,
CASE WHEN SLS_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price)
		THEN sls_quantity * abs(sls_price)
	ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE WHEN SLS_price is null or sls_price <= 0 
		THEN sls_sales / nullif(sls_quantity,0)
	ELSE sls_price
END AS sls_price
from bronze.crm_sales_details


PRINT '===========================================';
PRINT 'bronze.erp_cust_az12';
PRINT '===========================================';

select
case when cid like 'NAS%' then substring(cid, 4, len(cid))
	else cid
end cid,
bdate,
gen
from bronze.erp_cust_az12

--Identify out-of-range dates

--check for very old customers
--check for birthdays in the future
select distinct
bdate
from bronze.erp_cust_az12
where bdate < '1924-01-01' or bdate > GETDATE()

--data standardization & consistency
SELECT Distinct 
gen,
case when upper(trim(gen)) in ('F', 'FEMALE') THEN 'Female'
	when upper(trim(gen)) in ('M','MALE') then 'Male'
	ELSE 'n/a'
END AS gen
from bronze.erp_cust_az12


select
case when cid like 'NAS%' then substring(cid, 4, len(cid))
	else cid
end cid,
case when bdate > GETDATE() THEN NULL
	ELSE bdate
END AS bdate,
case when upper(trim(gen)) in ('F', 'FEMALE') THEN 'Female'
	when upper(trim(gen)) in ('M','MALE') then 'Male'
	ELSE 'n/a'
END AS gen
from bronze.erp_cust_az12



insert into silver.erp_cust_az12 
(cid,bdate,gen)
select
case when cid like 'NAS%' then substring(cid, 4, len(cid))
	else cid
end cid,
case when bdate > GETDATE() THEN NULL
	ELSE bdate
END AS bdate,
case when upper(trim(gen)) in ('F', 'FEMALE') THEN 'Female'
	when upper(trim(gen)) in ('M','MALE') then 'Male'
	ELSE 'n/a'
END AS gen
from bronze.erp_cust_az12

select distinct 
gen from silver.erp_cust_az12

PRINT '===========================================';
PRINT 'bronze.erp_loc_a101';
PRINT '===========================================';

--data standardization & consistency
select distinct cntry
from bronze.erp_loc_a101
order by cntry


insert into silver.erp_loc_a101
(cid,cntry)

select
REPLACE(cid,'-','') cid,
case when TRIM(cntry) = 'DE' then 'Germany'
	 when TRIM(cntry) IN ('US','USA') then 'United States'
	 when TRIM(cntry) = '' OR cntry IS NULL then 'n/a'
	 else TRIM(cntry)
END as cntry
from bronze.erp_loc_a101