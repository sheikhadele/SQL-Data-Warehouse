Data cleaning/transforming

--Checking if there are unwanted spaces.

SELECT CAT, 
SUBCAT,
MAINTENANCE FROM bronze.erp_PX_CAT_G1V2
WHERE CAT != TRIM(CAT) OR SUBCAT != TRIM(SUBCAT) OR 
MAINTENANCE != TRIM(MAINTENANCE);

----Checking if there are inconsistency

SELECT DISTINCT CAT FROM bronze.erp_PX_CAT_G1V2;
SELECT DISTINCT SUBCAT FROM bronze.erp_PX_CAT_G1V2;
SELECT DISTINCT MAINTENANCE FROM bronze.erp_PX_CAT_G1V2;

SELECT ID, 
CAT, 
SUBCAT,
MAINTENANCE 
FROM bronze.erp_PX_CAT_G1V2;

--No transformation needed here since all the data is fine.

----------------------------------
Creating table silver.erp_PX_CAT_G1V2
------------------------------------

CREATE TABLE silver.erp_PX_CAT_G1V2
(ID VARCHAR(50),
    CAT VARCHAR(50),
    SUBCAT VARCHAR(50),
    MAINTENANCE VARCHAR(50));

----------------------------
Inserting data
----------------------------

    INSERT INTO silver.erp_PX_CAT_G1V2
    (
    ID,
    CAT,
    SUBCAT,
    MAINTENANCE
    )
    SELECT ID, 
CAT, 
SUBCAT,
MAINTENANCE 
FROM bronze.erp_PX_CAT_G1V2;
