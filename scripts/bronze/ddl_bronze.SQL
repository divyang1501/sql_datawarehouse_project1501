/*We're going to insert the data directly into this tables
straight from csv files using command BULK INSERT
here you always need to specify extra info such as 
from where actual coloumn starts and what are seperators etc.*/


--adding truncate command so even we run command twice the values gets inserted once only

--Making stored procedure of whole query if we want to frequently use it

create or alter procedure bronze.load_bronze as
begin
    DECLARE @start_time datetime, @end_time datetime
	begin try

	--adding start-time to know when loading started 
	    set @start_time=getdate();
		truncate table bronze.crm_cust_info;
		bulk insert bronze.crm_cust_info
		from 'C:\Users\Shruti Solanki\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with(
		 firstrow=2,     --it denotes the actual data starts from 2nd row, because first_row contains coloumn_name in csv
		 fieldterminator=',', --it denotes that each value is separated by comma (,)
		 tablock --it make sure that while the loading our csv file is locked, optimizes loading
		);
		set @end_time=getdate()
		print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+'second';  


		--performing insertion for all six tables--
		set @start_time=getdate();
		truncate table bronze.crm_prd_info;
		bulk insert bronze.crm_prd_info
		from 'C:\Users\Shruti Solanki\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with(
		 firstrow=2,     
		 fieldterminator=',',
		 tablock 
		);
		set @end_time=getdate();
		print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+'second';


		set @start_time=getdate();
		truncate table bronze.crm_sales_details;
		bulk insert bronze.crm_sales_details
		from 'C:\Users\Shruti Solanki\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with(
		 firstrow=2,     
		 fieldterminator=',',
		 tablock 
		);
		set @end_time=getdate();
		print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+'second';
		
		
		set @start_time=getdate();
		truncate table bronze.erp_cust_AZ12;
		bulk insert bronze.erp_cust_AZ12
		from 'C:\Users\Shruti Solanki\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with(
		 firstrow=2,     
		 fieldterminator=',',
		 tablock 
		);
		set @end_time=getdate();
		print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+'second';


		set @start_time=getdate();
		truncate table bronze.erp_loc_A101;
		bulk insert bronze.erp_loc_A101
		from 'C:\Users\Shruti Solanki\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with(
		 firstrow=2,     
		 fieldterminator=',',
		 tablock 
		);
		set @end_time=getdate();
		print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+'second';



		set @start_time=getdate()
		truncate table bronze.erp_px_cat_G1V2;
		bulk insert bronze.erp_px_cat_G1V2
		from 'C:\Users\Shruti Solanki\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with(
		 firstrow=2,     
		 fieldterminator=',',
		 tablock 
		);
		set @end_time=getdate()
		print'>> Load Duration: '+ cast(datediff(second,@start_time,@end_time) as nvarchar)+'second';

	end try
	begin catch
	  print'===================================================='
	  print'ERROR OCCURED DURING LOADING OF BRONZE LAYER'
	  print'ERROR MESSAGE'+ERROR_MESSAGE();
	  print'ERROR MESSAGE'+CAST(ERROR_NUMBER() AS NVARCHAR);
	  print'ERROR MESSAGE'+CAST(ERROR_STATE()AS NVARCHAR);

	end catch
end
 
