select
CASE WHEN Q.PRODUCT_CATEGORY_ID IN (2) THEN C.BIOMED_AM 
	WHEN Q.PRODUCT_CATEGORY_ID IN (1,3) THEN C.IMAGING_AM ELSE "UKNOWN" END AS AM 
, count(distinct case when requests =1 then requestor_id else . end) as Unique_Requestors
, count(distinct case when requests =1 then customer_id else . end) as Unique_Customers
, sum(requests) as Requests
, sum(Orders) as Orders
, sum(orders)/sum(requests) as Close_Rate format = percent7.2
, sum(revenue) as Commissionable_Revenue format = dollar15.2
, sum(Margin) as Commissionable_Margin format = dollar15.2
, sum(Margin)/sum(revenue) as Margin_Pct format = percent7.2
from d_dw.RORM_ALL  q  
LEFT JOIN D_DW.CUSTOMERS C ON C.COMPANY_ID = Q.CUSTOMER_ID 
 and c.lvl1_company_id not in (38451,53610,53611,145379) /*LEB - 3/12/2021 | LEB added 145379 7/20/22*/

where q.transaction_date between "&start_date"d and "&end_date"d  
group by AM 

select count(*)
from DW.RORM_ALL where sta