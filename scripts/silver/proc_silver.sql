--CREATING SP FOR ALL SIX TABLES OF SILVER LAYER
--ADDING TRUNCATE AND PRINT LINE


CREATE OR ALTER PROCEDURE silver.load_silver as
BEGIN
    DECLARE @start_time datetime, @end_time datetime, @batch_start_time DATETIME, @batch_end_time DATETIME;
	    begin try
            set @batch_start_time=getdate();
            PRINT'==========================================================';
            PRINT'LOADING SILVER LAYER';
            PRINT'==========================================================';

            PRINT'----------------------------------------------------------';
            PRINT'Loading CRM Tables';
            PRINT'----------------------------------------------------------';

    --Loading silver.crm_cust_info
    SET @start_time=GETDATE()
    print '>> Truncating table : silver.crm_cust_info';
    TRUNCATE TABLE silver.crm_cust_info
    print '>> Inserting data into:silver.crm_cust_info';
    insert into silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date)

    select
    cst_id,
    cst_key,
    trim(cst_firstname) as cst_firstname,
    trim(cst_lastname) as cst_lastname,

    case when upper(trim(cst_marital_status))='S' then 'Single'
         when upper(trim(cst_marital_status))='M' then 'Married'
         else 'n/a' --if null replaced by n/a
    end cst_marital_status,

    case when upper(trim(cst_gndr))='F' then 'Female'
         when upper(trim(cst_gndr))='M' then 'Male'
         else 'n/a' --if null replaced by n/a
    end cst_gndr , --normalise marital status values to readable format
    cst_create_date
    from (
    select  --this query selects only unique_st id eliminates duplicates
      * ,
      row_number() over(partition by cst_id order by cst_create_date desc) as flag_last
      from bronze.crm_cust_info
      where cst_id is not null
      )t
      where flag_last=1;--select the most recentg record per customer
      set @end_time=getdate()
		    print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+' second ';
            PRINT'>>---------------'

    --Loading silver.crm_prd_info
    SET @start_time=GETDATE()
    print '>> Truncating table : silver.crm_prd_info';
    TRUNCATE TABLE silver.crm_prd_info
    print '>> Inserting data into:silver.crm_prd_info';
    insert into silver.crm_prd_info(
     prd_id,
     cat_id,
     prd_key,
     prd_nm,
     prd_cost,
     prd_line,
     prd_start_dt,
     prd_end_dt
     )
    select
    prd_id,
    replace(substring(prd_key,1,5),'-','_') as cat_id,
    substring(prd_key,7,len(prd_key)) as prd_key,
    prd_nm,
    coalesce(prd_cost,0) as prd_cost,
    case 
    when upper(trim(prd_line))='M' then 'Mountain'
    when upper(trim(prd_line))='R' then 'Road'
    when upper(trim(prd_line))='S' then 'Sport'
    when upper(trim(prd_line))='T' then 'Touring'
    else 'n/a'
    end as prd_line,
    prd_start_dt,
    dateadd(
     DAY,
     -1,
     lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)
     ) as prd_end_dt
    from bronze.crm_prd_info
    SET @end_time=GETDATE();
    print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+' second ';
    PRINT'>>---------------'

    --Loading silver.crm_sales_details
    SET @start_time=GETDATE();
    print '>> Truncating table : silver.crm_sales_details';
    TRUNCATE TABLE silver.crm_sales_details
    print '>> Inserting data into:silver.crm_sales_details';
    insert into silver.crm_sales_details(
	    sls_ord_num, 
	    sls_prd_key, 
	    sls_cust_id ,
	    sls_order_dt ,
	    sls_ship_dt ,
	    sls_due_dt ,
	    sls_sales ,
	    sls_quantity ,
	    sls_price 
        )
    select
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,

    case when (sls_order_dt)=0 or len(sls_order_dt)!=8 then null
         else cast(cast(sls_order_dt as nvarchar) as date)
    end as sls_order_dt,

    case when(sls_ship_dt)=0 or len(sls_ship_dt)!=8 then null
         else cast(cast(sls_ship_dt as nvarchar)as date)
    end as sls_ship_dt,

    case when(sls_due_dt)=0 or len(sls_order_dt)!=8 then null
         else cast(cast(sls_due_dt as nvarchar)as date)
    end as sls_due_dt,

    case when sls_sales <=0 or sls_sales is null or sls_sales != sls_quantity* abs(sls_price)
         then sls_quantity*abs(sls_price)
         else sls_sales --very imp line or everything will be null
    end as sls_sales,

    sls_quantity,
    case when sls_price <=0 or sls_price is null then
               sls_sales/nullif(sls_quantity,0)
        else sls_price
    end sls_price
    from bronze.crm_sales_details
    SET @end_time=GETDATE();
    print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+' second ';
    PRINT'>>---------------'

    --Loading silver.erp_cust_AZ12
    SET @start_time= GETDATE();
    print '>> Truncating table : silver.erp_cust_AZ12';
    TRUNCATE TABLE silver.erp_cust_AZ12
    print '>> Inserting data into:silver.erp_cust_AZ12';
    insert into silver.erp_cust_AZ12 (
    cid,
    bdate,
    gen)
    select
    case when cid like '%NAS%' then substring(cid,4,len(cid))
         else cid
    end cid,
    case when bdate>getdate() then null
         else bdate
    end bdate,
    case when gen is null or gen='' then 'n/a'
         when gen ='F' then 'Female'
         when gen ='M' then 'Male'
         else gen
    end gen
    from bronze.erp_cust_az12
    SET @end_time=GETDATE();
    print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+' second ';
    PRINT'>>---------------'

    --Loading erp_loc_A101
    SET @start_time=GETDATE();
    print '>> Truncating table : silver.erp_loc_A101';
    TRUNCATE TABLE silver.erp_loc_A101
    print '>> Inserting data into:silver.erp_loc_A101';
    insert into silver.erp_loc_A101 (
    cid,
    cntry
    )
    select
    replace(cid,'-','') as cid,
    case when trim(cntry)='DE' then 'Germany'
         when trim(cntry) IN ('US','USA') then 'United States'
         when trim(cntry)='' or cntry is null then 'n/a'
         else trim(cntry)
    end as cntry
    from bronze.erp_loc_A101
    SET @end_time=GETDATE();
    print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+' second ';
    PRINT'>>---------------'

    --Loading silver.px_cat_G1V2
    SET @start_time=GETDATE();
    print '>> Truncating table : silver.px_cat_G1V2';
    TRUNCATE TABLE silver.px_cat_G1V2
    print '>> Inserting data into:silver.px_cat_G1V2';
    insert into silver.px_cat_G1V2(
    id,
    cat,
    subcat,
    maintenance
    )
    SELECT
    id,
    cat,
    subcat,
    maintenance
    FROM bronze.erp_px_cat_G1V2
    SET @end_time=GETDATE();
    print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+' second ';
    PRINT'>>---------------'
    
    SET @batch_end_time=GETDATE();
    PRINT'=========================================='
    PRINT'Loading Silver Layer is completed';
    PRINT'    Total Load Duration:' + cast(datediff(second,@batch_start_time,@batch_end_time)as nvarchar);
    PRINT'=========================================='
end try
BEGIN CATCH
    PRINT'==========================================='
    PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER'
    PRINT'Error Message'+ ERROR_MESSAGE();
    PRINT'Error Message'+ CAST(ERROR_NUMBER() AS NVARCHAR);
    PRINT'Error Message'+CAST(ERROR_STATE() AS NVARCHAR);
    PRINT'============================================'
END CATCH
END

EXEC silver.load_silver
