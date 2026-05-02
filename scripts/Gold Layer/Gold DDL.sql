/*
  ===============================================================================
	 Gold DDL: Creates views for gold layer
	===============================================================================
	GOld DDL models and aggregates the data from multiple table and present views having relevent 
	information. These view are used for data analytics.

*/ 
create view gold.prod_details as (   --- creates prod_details dimension
select prod_name, cpi.prod_line ,cat , subcat, prod_cost, epc.maintenance ,cpi.prod_start_dt 
,cpi.prod_end_dt ,prod_id, prod_key
from silver.crm_prod_info cpi 
left join silver.erp_px_cat epc on 
cpi.cat_id =epc.id)


create view gold.customer_details as  --- creates customer dimension
(
select  cci.cust_firstname ,cci.cust_lastname , cci.cust_marital_status ,
case 
	when cust_gender is null then ec."case"
	else 
	cust_gender
end
,country ,
cci.cust_id, bdate, row_number() over (order by cci.cust_key ) as customer_id
from silver.crm_cust_info cci 
left join silver.erp_loc el
on cci.cust_key =el.cid 
left join silver.erp_cust ec on
cci.cust_key = ec.cid 
)

create view gold.sales_details as (   --- creates fact table
select
csd.sales_price, csd.sales_quant,
csd.sales_sold as total_sales_amt,
csd.sales_order_dt , csd.sales_ship_dt ,csd.sales_due_dt 
,cd.customer_id , pd.prod_id, 
row_number() over (order by sales_ord_num) as sales_id
from silver.crm_sales_details csd 
left join gold.customer_details cd 
on cd.cust_id =csd.sales_cust_id 
left join gold.prod_details pd 
on pd.prod_key =csd.sales_prod_key 
)



