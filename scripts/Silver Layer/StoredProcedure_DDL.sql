CREATE OR REPLACE PROCEDURE silver.inserting_values()
LANGUAGE plpgsql
AS $$
BEGIN
  EXECUTE '
    CREATE TABLE IF NOT EXISTS silver.crm_sales_details AS
    SELECT
      csd.sales_ord_num,
      csd.sales_prod_key,
      csd.sales_cust_id,
      CASE
        WHEN length(csd.sales_order_dt::text) < 8 OR csd.sales_order_dt = 0 THEN NULL
        ELSE csd.sales_order_dt::text::date
      END AS sales_order_dt,
      CASE
        WHEN length(csd.sales_ship_dt::text) < 8 OR csd.sales_ship_dt = 0 THEN NULL
        ELSE csd.sales_ship_dt::text::date
      END AS sales_ship_dt,
      CASE
        WHEN length(csd.sales_due_dt::text) < 8 OR csd.sales_due_dt = 0 THEN NULL
        ELSE csd.sales_due_dt::text::date
      END AS sales_due_dt,
      CASE
        WHEN (sales_price >= sales_sold AND sales_price > 0) THEN sales_price * csd.sales_quant
        ELSE abs(sales_sold)
      END AS sales_sold,
      csd.sales_quant,
      abs(csd.sales_price) AS sales_price,
      current_timestamp::timestamp AS dwt_create_date
    FROM bronze.crm_sales_details csd
  ';

  EXECUTE '
    CREATE TABLE IF NOT EXISTS silver.crm_prod_info AS
    SELECT
      prod_id,
      prod_key,
      replace(substring(trim(prod_key),1,5), ''-'',''_'') AS cat_id,
      prod_name,
      CASE WHEN prod_cost IS NULL THEN 0 ELSE prod_cost END,
      CASE
        WHEN trim(cpi2.prod_line) = ''R'' THEN ''ROAD''
        WHEN trim(cpi2.prod_line) = ''M'' THEN ''MOUNTAIN''
        WHEN trim(cpi2.prod_line) = ''S'' THEN ''OTHER SALES''
        WHEN trim(cpi2.prod_line) = ''T'' THEN ''TOURING''
        ELSE cpi2.prod_line
      END AS prod_line,
      prod_start_dt,
      lead(cpi2.prod_start_dt) over (
        partition by cpi2.prod_name
        order by prod_key, prod_start_dt
      ) AS prod_end_dt,
      current_timestamp::date AS dwt_create_date
    FROM bronze.crm_prod_info cpi2
  ';

  EXECUTE '
    CREATE TABLE IF NOT EXISTS silver.erp_cust AS
    SELECT
      CASE
        WHEN cid LIKE ''NAS%'' THEN substring(cid, 4, length(cid))
        ELSE ec.cid
      END AS cid,
      CASE
        WHEN bdate > current_timestamp::date THEN NULL
        ELSE bdate
      END AS bdate,
      CASE trim(gen)
        WHEN ''F'' THEN ''FEMALE''
        WHEN ''M'' THEN ''MALE''
        WHEN ''Male'' THEN ''MALE''
        WHEN ''Female'' THEN ''FEMALE''
        ELSE NULL
      END AS gender,
      current_timestamp::date AS dwt_create_date
    FROM bronze.erp_cust ec
  ';

  EXECUTE '
    CREATE TABLE IF NOT EXISTS silver.erp_loc AS
    SELECT
      CASE
        WHEN cid LIKE ''AW-%'' THEN replace(cid,''-'','''')
        ELSE el.cid
      END AS cid,
      CASE upper(trim(country))
        WHEN '''' THEN NULL
        WHEN ''DE'' THEN ''Germany''
        WHEN ''US'' THEN ''USA''
        WHEN ''UNITED STATES'' THEN ''USA''
        ELSE country
      END AS country,
      current_timestamp::date AS dwt_create_date
    FROM bronze.erp_loc el
  ';

  EXECUTE '
    CREATE TABLE IF NOT EXISTS silver.erp_px_cat AS
    SELECT * FROM bronze.erp_px_cat
  ';
END;
$$;




