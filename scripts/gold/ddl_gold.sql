/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================

create view gold.dim_customers as
SELECT 
    ROW_NUMBER() over (order by cst_id) AS customer_key,
    cst_id          as customer_id,
    cst_key         as customer_number,
    cst_firstname   as first_name,
  	cst_lastname      as last_name,
	  cntry             as country,
    cst_material_status as marital_status,
    new_gen       as gender,
	  bdate         as birthday,
    cst_create_date as create_date
FROM (
    SELECT
        ci.cst_id,
        ci.cst_key,
        ci.cst_firstname,
		ci.cst_lastname,
        ci.cst_material_status,
        case when ci.cst_gndr != 'n/a' then ci.cst_gndr   --CRM IS THE MASTER FOR GENDER INFO
		ELSE COALESCE(ca.gen, 'n/a')
		END AS new_gen,
        ci.cst_create_date,
        ca.bdate,
        la.cntry,
        ROW_NUMBER() OVER (PARTITION BY ci.cst_id ORDER BY ci.cst_create_date DESC) AS rn
    FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_cust_az12 ca
        ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 la
        ON ci.cst_key = la.cid
) t
WHERE rn = 1;


-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================

--create view

CREATE VIEW gold.dim_products as
SELECT 
	   ROW_NUMBER() OVER (ORDER BY prd_start_dt, prd_key) AS product_key,
	   prd_id       as product_id,
	   cat_id       as product_number,
	   prd_key      as product_name,
	   prd_nm       as category_id,
	   cat          as category,
	   subcat       as subcategory,
     maintenance,
     prd_cost     as cost,
     prd_line     as product_line,
     prd_start_dt as start_date
FROM (
    select
	pn.prd_id,
	pn.prd_key,
	pc.cat,
	pc.subcat,
	pn.cat_id,
	pc.maintenance,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	ROW_NUMBER() OVER(PARTITION BY prd_id ORDER BY prd_start_dt DESC) AS rn,
	pn.prd_start_dt
	from silver.crm_prd_info pn
	left join silver.erp_px_cat_g1v2 pc
	on pn.cat_id = pc.id
	where prd_end_dt IS NULL
) t
WHERE rn = 1;

select * from gold.dim_products


PRINT '==============================================='
PRINT'   Create Fact Table: gold.fact_sales          '
PRINT '==============================================='

--use the dimension's surrogate key instead of IDs to easily connect facts with dimensions

CREATE VIEW gold.fact_sales AS
	select
	sd.sls_ord_num        AS order_number,
	--sd.sls_prd_key,
	pr.product_key,
	--sd.sls_cust_id,
	cu.customer_key,
	sd.sls_order_dt       AS order_date,
	sd.sls_ship_dt        AS shipping_date,
	sd.sls_due_dt         AS due_date,
	sd.sls_sales          AS sales_amount,
	sd.sls_quantity       AS quantity,
	sd.sls_price
	from silver.crm_sales_details sd
	left join gold.dim_products pr
	ON sd.sls_prd_key = pr.product_name
	left join gold.dim_customers cu
	on sd.sls_cust_id = cu.customer_id


--Foreign key Integrity (Dimensions)
--CHECK IF ALL DIMENSION TABLES CAN SUCCESSFULLY JOIN TO THE FACT TABLE
SELECT * FROM gold.fact_sales f
left join gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL
