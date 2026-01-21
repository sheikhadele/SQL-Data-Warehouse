Performing ETL - Extract, Transform and Load the data. This process takes places in three layers, Bronze, Silver and Gold.

In Bronze layer the data is imported from two sources (crm and erp) provided as csv files. In the bronze layer no data transformation will be done.

Hence creating a schema Bronze.

CREATE Schema BRONZE;

CREATE TABLE bronze.crm_cust_info(
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gender VARCHAR(50),
    cst_create_date DATE
);

CREATE TABLE bronze.crm_prd_info(
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_date DATE,
    prd_end_date DATE
);

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt VARCHAR(50),
    sls_ship_dt VARCHAR(50),
    sls_due_dt VARCHAR(50),
    sls_sales VARCHAR(50),
    sls_quantity INT,
    sls_price VARCHAR(50)
);

CREATE TABLE bronze.erp_cust_az12(
    CID VARCHAR(50),
    BDATE DATE,
    GEN VARCHAR(50)
);

CREATE TABLE bronze.erp_LOC_A101(
    CID VARCHAR(50),
    CNTRY VARCHAR(50)
);

CREATE TABLE bronze.erp_PX_CAT_G1V2(
    ID VARCHAR(50),
    CAT VARCHAR(50),
    SUBCAT VARCHAR(50),
    MAINTENANCE VARCHAR(50)
);

--The data inserted in the tables using query;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\file_name.csv'
INTO TABLE table_name
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gender, cst_created_date)
SET cst_id = NULLIF(TRIM(@cst_id), '');

