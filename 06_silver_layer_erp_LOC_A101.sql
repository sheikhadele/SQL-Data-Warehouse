--Data cleaning/transforming

--To check for any inconsistency

SELECT DISTINCT CNTRY FROM bronze.erp_LOC_A101;

Short form are replaced with full form.

CASE WHEN TRIM(CNTRY) IS NULL THEN 'n/a'
    WHEN TRIM(CNTRY) IN ('DE') THEN 'Germany'
    WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
    ELSE TRIM(CNTRY)
    END as CNTRY

The final query becomes;

SELECT
REPLACE(CID, '-', '') CID,
CASE WHEN TRIM(CNTRY) IS NULL THEN 'n/a'
    WHEN TRIM(CNTRY) IN ('DE') THEN 'Germany'
    WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
    ELSE TRIM(CNTRY)
    END as CNTRY
FROM bronze.erp_LOC_A101;

------------------------
Creating table silver.erp_LOC_A101
----------------------------------

CREATE TABLE Silver.erp_LOC_A101
(
   CID VARCHAR(50),
    CNTRY VARCHAR(50) 
);

-------------------------
Inserting data
----------------------------

INSERT INTO Silver.erp_LOC_A101(
CID,
    CNTRY)
SELECT
REPLACE(CID, '-', '') CID,
CASE WHEN TRIM(CNTRY) IS NULL THEN 'n/a'
    WHEN TRIM(CNTRY) IN ('DE') THEN 'Germany'
    WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
    ELSE TRIM(CNTRY)
    END as CNTRY
FROM bronze.erp_LOC_A101;