--naming according to naming conventions--
--created table for bronze layer--

/*in order to check if any table already exists and we're recreating it
 we run a T-SQL command which drops and creates table from scratch if already exists*/

if object_id ('bronze.crm_cust_info','U') is not null
drop table bronze.crm_cust_info;
create table bronze.crm_cust_info(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_material_status nvarchar(50),
	cst_gender nvarchar(10),
	cst_create_date date
);

if object_id ('bronze.crm_prd_info','U') is not null
drop table bronze.crm_prd_info;
create table bronze.crm_prd_info(
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line varchar(10),
	prd_start_dt date,
	prd_end_dt date
);

--creating table for sales details--
if object_id ('bronze.crm_sales_details','U') is not null
drop table bronze.crm_sales_details;
create table bronze.crm_sales_details (
	sls_ord_num int,
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price int
);

/*here we created DDL statement for source_crm,and now
creating same for another sources too*/

--Creating tables for source_erp--
if object_id ('bronze.erp_cust_AZ12','U') is not null
drop table bronze.erp_cust_AZ12;
create table bronze.erp_cust_AZ12(
	cid int,
	bdate date,
	gen varchar(10)
);

if object_id ('bronze.erp_loc_A101','U') is not null
drop table bronze.erp_loc_A101;
create table bronze.erp_loc_A101(
cid int,
cntry nvarchar(50)
);

if object_id ('bronze.px_cat_G1V2','U') is not null
drop table bronze.px_cat_G1V2;
create table bronze.px_cat_G1V2(
id int,
cat nvarchar(50),
subcat nvarchar(50),
maintenance nvarchar(10)
);


