--Proc Sql;
--create table Integrations as
select
channel_code as Channel_Code
,catalog as Catalog
,subscription_name as CMMS_ERP
,sum(requests) as Requests
,sum(Orders) as Orders
,sum(Orders)/sum(requests) as Close_Rate
,Sum(Revenue) as Revenue
,sum(margin) as Margin 
from DW.RORM_ALL q
inner join dw.line_item_details l on l.line_item_id = q.line_item_id and l.contract_pro_id is null
where year(q.transaction_date) = 2021
group by channel_code
        ,catalog
        ,subscription_name
------------------------------------------------------------------------------------------------------
select
c.COMPANY_Id
,c.company_Name
,channel_code as Channel_Code
,catalog as Catalog
,subscription_name as CMMS_ERP
,sum(requests) as Requests
,sum(Orders) as Orders
,sum(Orders)/sum(requests) as Close_Rate
,Sum(Revenue) as Revenue
,sum(margin) as Margin 
from DW.RORM_ALL q
inner join dw.line_item_details l on l.line_item_id = q.line_item_id and l.contract_pro_id is null
inner join DW.CUSTOMERS c on c.COMPANY_ID = l.CUSTOMER_ID
where year(q.transaction_date) = 2021
group by channel_code
        ,catalog
        ,subscription_name