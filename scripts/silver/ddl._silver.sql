--DDL Commands for silver layer
--we are going to do truncate and insert
--importing all silver ddl command and replacing silver with silver keyword


--naming according to naming conventions--
--created table for silver layer--

/*in order to check if any table already exists and we're recreating it
 we run a T-SQL command which drops and creates table from scratch if already exists*/

if object_id ('silver.crm_cust_info','U') is not null
drop table silver.crm_cust_info;
create table silver.crm_cust_info(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(10),
	cst_create_date date,
	dwh_create_date datetime2 default getdate()
);

if object_id ('silver.crm_prd_info','U') is not null
drop table silver.crm_prd_info;
create table silver.crm_prd_info(
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line varchar(10),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date datetime2 default getdate()
);

--creating table for sales details--
if object_id ('silver.crm_sales_details','U') is not null
drop table silver.crm_sales_details;
create table silver.crm_sales_details (
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price int,
	dwh_create_date datetime2 default getdate()
);

/*here we created DDL statement for source_crm,and now
creating same for another sources too*/

--Creating tables for source_erp--
if object_id ('silver.erp_cust_AZ12','U') is not null
drop table silver.erp_cust_AZ12;
create table silver.erp_cust_AZ12(
	cid nvarchar(50),
	bdate date,
	gen varchar(10),
	dwh_create_date datetime2 default getdate()
);

if object_id ('silver.erp_loc_A101','U') is not null
drop table silver.erp_loc_A101;
create table silver.erp_loc_A101(
cid nvarchar(50),
cntry nvarchar(50),
dwh_create_date datetime2 default getdate()
);

if object_id ('silver.px_cat_G1V2','U') is not null
drop table silver.px_cat_G1V2;
create table silver.px_cat_G1V2(
id nvarchar(50),
cat nvarchar(50),
subcat nvarchar(50),
maintenance nvarchar(10),
dwh_create_date datetime2 default getdate() 
);
