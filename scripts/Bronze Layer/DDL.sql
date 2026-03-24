
create table bronze.crm_cust_info
(cust_id int ,
cust_key text,
cust_firstname text,
cust_lastname text,
cust_marital_status text,
cust_gender text,
cust_create_date date
)

create table bronze.crm_prod_info
(prod_id int,
prod_key text,
prod_name text,
prod_cost int,
prod_line text,
prod_start_dt date,
prod_end_dt date
)


create table bronze.crm_sales_details
(
sales_ord_num text,
sales_prod_key text,
sales_cust_id int,
sales_order_dt int,
sales_ship_dt int,
sales_due_dt int, 
sales_sold int,
sales_quant int,
sales_price decimal
)


create table bronze.crm_

\copy bronze.crm_cust_info from 'C:/Users/ZDJW6853/Desktop/projects/sql-warehouse/dataset/source_crm/cust_info.csv' delimiter ',' csv header;
\copy bronze.crm_prod_info from 'C:/Users/ZDJW6853/Desktop/projects/sql-warehouse/dataset/source_crm/prd_info.csv' delimiter ',' csv header;
\copy bronze.crm_sales_details from 'C:/Users/ZDJW6853/Desktop/projects/sql-warehouse/dataset/source_crm/sales_details.csv' delimiter ',' csv header;





create table bronze.erp_cust
(cid text,
bdate date,
gen text
);


create table bronze.erp_loc
(
	cid text,
	country text
)

create table bronze.erp_px_cat
(
id text, 
cat text,
subcat text,
maintenance text
)





\copy bronze.erp_cust from 'C:/Users/ZDJW6853/Desktop/projects/sql-warehouse/dataset/source_erp/cust_az12.csv' delimiter ',' csv header;
\copy bronze.erp_loc from 'C:/Users/ZDJW6853/Desktop/projects/sql-warehouse/dataset/source_erp/loc_a101.csv' delimiter ',' csv header;
\copy bronze.erp_px_cat from 'C:/Users/ZDJW6853/Desktop/projects/sql-warehouse/dataset/source_erp/px_cat_g1v2.csv' delimiter ',' csv header;
