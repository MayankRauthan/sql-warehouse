/*
 *  ===============================================================================
	 silver_test : Test the tables of silver schema
	===============================================================================

 * 
 * Majority of the transformation and data cleaning applied to silver layer are checked
 */



select * from silver.crm_cust_info cci 

select distinct cust_gender from silver.crm_cust_info cci -- Data standardization checks

select distinct cust_marital_status from silver.crm_cust_info cci 

select cust_id from silver.crm_cust_info cci 
group by cci.cust_id 
having count(*) >1   -- duplicates value check


select * from silver.crm_prod_info cpi 

select * from silver.crm_prod_info cpi 
where cpi.prod_start_dt > cpi.prod_end_dt  -- data validity

select * from silver.crm_prod_info cpi 
where replace(substring(trim(prod_key),1,5),'-','_') !=cat_id   

select * from silver.crm_prod_info cpi
where substring(prod_key,6,6) not like '-%'  -- cat_id check

select * from silver.crm_sales_details csd 

select * from silver.crm_sales_details csd 
where csd.sales_order_dt> csd.sales_ship_dt 

select * from silver.crm_sales_details csd 
where sales_sold<0  -- data validity

select * from silver.crm_sales_details csd 
left join silver.crm_prod_info cpi
on csd.sales_prod_key =cpi.prod_key   --- Data integration check


select * from silver.erp_px_cat epc 
left join silver.crm_prod_info cpi 
on epc.id=cpi.cat_id   -- Data integration check


select * from bronze.crm_sales_details csd 

select * from silver.crm_prod_info cpi 


update silver.crm_prod_info
set prod_key = substring(prod_key,7,length(prod_key))
