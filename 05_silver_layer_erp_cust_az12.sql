Data cleaning/transforming

--Check for NULL and Duplicates.

SELECT CID, COUNT(CID) as cn FROM bronze.erp_cust_az12
GROUP BY CID
HAVING CID >1 OR CID IS NULL;


--The data has CID, which is a customer ID, and as we know the CID is also present in another table crm_cust_info, But CID present in current table is in format NASAW00011000 and Customer ID present is crm_cust_info table is only AW00011000, Hence NAS is extra part present in this table, hence data is transformed to remove this extra part.

CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID,4, LENGTH(CID))
ELSE CID
END as CID

--Checking if BDATE does not make sense, or is from future date and checking if there are null.

SELECT BDATE FROM bronze.erp_cust_az12
WHERE BDATE IS NULL;

SELECT BDATE FROM bronze.erp_cust_az12
WHERE BDATE < 1924-01-01 OR BDATE > NOW();

The data has BDATE which is future dates hence need to make them NULL.

CASE WHEN BDATE > NOW() THEN NULL 
ELSE BDATE
END as BDATE

--Checking if there are insignificant values present in Gender GEN.

SELECT DISTINCT GEN FROM bronze.erp_cust_az12;

The Gender data has NULL and different forms.

CASE WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') Then 'Male'
    WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
    ElSE 'n/a'
    END as GEN


This becomes the transformed Final query;

SELECT
CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID,4, LENGTH(CID))
ELSE CID
END as CID,
CASE WHEN BDATE > NOW() THEN NULL 
ELSE BDATE
END as BDATE,
CASE WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') Then 'Male'
    WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
    ElSE 'n/a'
    END as GEN
FROM bronze.erp_cust_az12;

------------------------------------
Creating table silver.erp_cust_az12
------------------------------------

CREATE TABLE silver.erp_cust_az12
(CID VARCHAR(50),
    BDATE DATE,
    GEN VARCHAR(50)
);

------------------------------------
Inserting data
-------------------------------------

INSERT INTO silver.erp_cust_az12
(CID,
    BDATE,
    GEN
)
SELECT
CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID,4, LENGTH(CID))
ELSE CID
END as CID,
CASE WHEN BDATE > NOW() THEN NULL 
ELSE BDATE
END as BDATE,
CASE WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') Then 'Male'
    WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
    ElSE 'n/a'
    END as GEN
FROM bronze.erp_cust_az12;
