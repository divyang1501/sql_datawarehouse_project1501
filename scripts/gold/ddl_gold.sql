--====================================================
--CREATE DIMENTION TABLE FOR CUSTOMER: gold.dim_customers
--====================================================
IF OBJECT_ID('gold.dim_customers','V') is not null
   drop view gold.dim_customers;
go
create view gold.dim_customers as 
select
    row_number() over(order by cst_id) as customer_key, 
	ci.cst_id as customer_id ,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name ,
	ci.cst_marital_status as marital_status,
	case when ci.cst_gndr !='n/a' then ci.cst_gndr --CRM is master for gender info
      else coalesce(ca.gen,'n/a')
    end as gender,
	ci.cst_create_date as create_date,
	ca.bdate as birthdate,
	la.cntry as country
from silver.crm_cust_info as ci 
left join silver.erp_cust_AZ12 as ca
on ci.cst_key=ca.cid
left join silver.erp_loc_A101 as la
on ci.cst_key = la.cid

---==============================================================
--CREATE DIMENSION TABLE FOR PRODUCTS: gold.dim_products
--===============================================================
IF OBJECT_ID('gold.dim_products','V') is not null
   drop view gold.dim_products;
go
create view gold.dim_products as
select
row_number() over(order by pn.prd_start_dt,pn.prd_id)as product_key,
pn.prd_id as product_id,
pn.prd_key as product_number,
pn.prd_nm as product_name,
pn.cat_id as category_id,
pc.cat as category,
pc.subcat as subcategory,
pc.maintenance as maintenance,
pn.prd_cost as cost,
pn.prd_line as product_line,
pn.prd_start_dt as product_start_date
from silver.crm_prd_info as pn
left join silver.px_cat_G1V2 pc
on pn.cat_id=pc.id
where pn.prd_end_dt is null --filter out all historical data

--======================================================================
--CREATE FACT TABLE: gold.fact_sales
--======================================================================
IF OBJECT_ID('gold.fact_sales','V') is not null
   drop view gold.fact_sales;
go
create view gold.fact_sales as
select
sd.sls_ord_num as order_number,
pr.product_key as product_key,
cr.customer_key as customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales,
sd.sls_quantity as quantity,
sd.sls_price as price
from silver.crm_sales_details as sd
left join gold.dim_products as pr
on sd.sls_prd_key=pr.product_number
left join gold.dim_customers as cr
on sd.sls_cust_id=cr.customer_id

/*here we can clearly see it's a fact table
connected to multiple ids means connecting to multiple dimensions
so the informations prd_key and cust_id comes from source system
we will use surroagate keys of dimensions to join facts with dim
*/

/*this process of joining table using surrogate keys in order to join
fact and dim is called data lookup*/

--we will join sales_details with gold_dim and product_dim using 
--gold_dim_customers: customerid= sd.sls_cust_id and 
--gold.dim_products: product_number=sd.prd_key

/*here we have used surroagate keys: customer_key from dim_customer
  and product_key from dim_products,
  we have included the surrogate keys product_key and customer_key
*/

--in this way we have joined our fact with dimension
--quality check of gold.fact_sales
