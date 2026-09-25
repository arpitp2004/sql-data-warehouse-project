----------------------------------INSERTING THE 1ST ERP TABLE----------------------------------------------------
INSERT INTO silver.erp_cust_az12(cid,bdate,gen) 
SELECT
CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID,4,LEN(CID))
	 ELSE CID
 END AS CID,
 CASE WHEN BDATE > GETDATE() THEN  NULL
      ELSE BDATE
 END AS BDATE,
 CASE WHEN UPPER(TRIM(GEN)) IN ('F','FEMALE') THEN 'Female'
      WHEN UPPER(TRIM(GEN)) IN ('M','MALE') THEN 'Male'
      ELSE 'n/a'
END AS GEN
FROM bronze.erp_cust_az12

---------------------------INSERTING THE 2ND ERP TABLE------------------------------------------------------
INSERT INTO silver.erp_loc_a101(cid,cntry)

SELECT
REPLACE(CID,'-','') AS CID,
CASE WHEN TRIM(CNTRY) = 'DE' THEN 'GERMANY'
     WHEN TRIM(CNTRY) IN ('US','USA') THEN 'UNITED STATES'
     WHEN TRIM(CNTRY) = 'UK' THEN 'UNITED KINGDOM'
     WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'N/A'
     ELSE CNTRY
END AS CNTRY
FROM bronze.erp_loc_a101

----------------------------------INSERTING THE 3RD ERP TABLE------------------------------------------------
INSERT INTO silver.erp_px_cat_g1v2(id,cat,subcat,maintenance)
SELECT *
FROM bronze.erp_px_cat_g1v2
