# sql_datawarehouse_project1501
Building a modern data warehouse with SQL server, including ETL processes, data modeling and Analytics

📚 Data Catalog
Bronze Layer (Raw Data)
Table	Description
crm_cust_info	Stores raw customer information extracted from the CRM system without any transformations.
crm_prd_info	Stores raw product data imported from the CRM source.
crm_sales_details	Contains raw sales transaction records from the CRM system.
erp_cust_AZ12	Stores customer demographic information extracted from the ERP system.
erp_loc_A101	Contains customer location information from the ERP system.
erp_px_cat_G1V2	Stores product category and hierarchy information from the ERP system.

Silver Layer (Cleaned & Standardized Data)
Table	Description
crm_cust_info	Cleansed customer records with standardized values, duplicate removal, and validated attributes.
crm_prd_info	Cleaned product data with corrected category mappings and product history handling.
crm_sales_details	Validated sales transactions with corrected dates, quantities, and sales calculations.
erp_cust_AZ12	Standardized ERP customer information including gender and birthdate.
erp_loc_A101	Cleaned customer location data with standardized country names.
erp_px_cat_G1V2	Standardized product category hierarchy used for dimensional modeling.

Gold Layer (Business Model)
View	Description
dim_customers	Customer dimension combining CRM and ERP data into a unified customer profile.
dim_products	Product dimension enriched with category and product hierarchy information.
fact_sales	Central fact table containing sales transactions linked to customer and product dimensions.

📖 Data Dictionary
Gold – dim_customers
Column	Description
customer_key	Surrogate key generated for the customer dimension.
customer_id	Customer identifier from the CRM system.
customer_number	Business key used to uniquely identify customers.
first_name	Customer's first name.
last_name	Customer's last name.
marital_status	Customer marital status.
gender	Customer gender. CRM values take precedence over ERP values.
create_date	Date the customer record was created.
birthdate	Customer birth date obtained from ERP.
country	Customer country obtained from ERP location data.

Gold – dim_products
Column	Description
product_key	Surrogate key generated for each product.
product_id	Product identifier from CRM.
product_number	Business product key.
product_name	Product name.
category_id	Product category identifier.
category	Product category.
subcategory	Product subcategory.
maintenance	Product maintenance classification.
product_cost	Standard product cost.
product_line	Product line classification.
start_date	Product effective start date.

Gold – fact_sales
Column	Description
order_number	Unique sales order number.
product_key	Foreign key referencing dim_products.
customer_key	Foreign key referencing dim_customers.
order_date	Date the order was placed.
shipping_date	Date the order was shipped.
due_date	Order due date.
sales_amount	Total sales amount for the order line.
quantity	Quantity sold.
price	Unit selling price.

🔄 Data Lineage
CRM System ───────────────┐
                           │
ERP System ───────────────┤
                           ▼
                    Bronze Layer
                 (Raw Source Data)
                           │
                           ▼
                    Silver Layer
            (Cleaning & Validation)
                           │
                           ▼
                     Gold Layer
     (Star Schema for Business Analytics)
                           │
                           ▼
               Dashboards & Reporting
📌 Business Rules
CRM is the master source for customer names and gender.
ERP data supplements missing customer demographic information.
Surrogate keys are generated for all dimension tables.
Product hierarchy is enriched using ERP category mappings.
Invalid sales, dates, and quantities are corrected during Silver transformations.
Gold views expose business-ready datasets optimized for analytics.
