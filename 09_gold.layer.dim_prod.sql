Data integration.

Final query after giving friendly names to the columns and surrogate key.

SELECT
ROW_NUMBER() OVER(ORDER BY prd_start_date, prd_key) as product_key,
    prd_id AS product_id,
    prd_key AS product_number,
    prd_nm AS product_name,
    cat_id AS catagory_id,
    pc.CAT AS catagory,
    pc.SUBCAT AS subcatagory,
    pc.MAINTENANCE AS maintenance,
    prd_cost AS cost,
    prd_line AS product_line,
    prd_start_date AS start_date
FROM silver.crm_prd_info pn
JOIN silver.erp_PX_CAT_G1V2 pc ON
pn.cat_id = pc.ID
WHERE prd_end_date IS NULL);

-----------------------------------
Creating View
-----------------------

CREATE VIEW gold.dim_products AS(
SELECT
ROW_NUMBER() OVER(ORDER BY prd_start_date, prd_key) as product_key,
    prd_id AS product_id,
    prd_key AS product_number,
    prd_nm AS product_name,
    cat_id AS catagory_id,
    pc.CAT AS catagory,
    pc.SUBCAT AS subcatagory,
    pc.MAINTENANCE AS maintenance,
    prd_cost AS cost,
    prd_line AS product_line,
    prd_start_date AS start_date
FROM silver.crm_prd_info pn
JOIN silver.erp_PX_CAT_G1V2 pc ON
pn.cat_id = pc.ID
WHERE prd_end_date IS NULL);