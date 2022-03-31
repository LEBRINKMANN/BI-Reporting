--2- Customer Order Initated 
Select catalog, count(catalog) 
from DW.F_AR_TRANSACTION_LINES q
where orders_ind = 1 and q.TRANSACTION_DATE between '1-1-2021' and '1-31-2021'
group by catalog
with ur;

--3-Customer Closed 
WITH  closed_stats AS (select ls.LINE_ITEM_ID
      ,ls.FIRST_CLOSED_TIMESTAMP
      ,c.COMPANY_ID
      ,C.COMPANY_NAME
      ,c.LVL1_COMPANY_ID
      ,C.LVL1_COMPANY_NAME
      ,case when bt.updated_user_id is null then 'Auto'
              when o.organization_id is null then 'Auto'
              when bt.updated_user_id= 3 then 'Auto'
              when o.organization_id is not null then 'Manually' else 'ERROR' end as CLSD
      ,sum(orders) as orderS 
      , sum(q.revenue) as revenue
      , q.channel_code
from DW.LINE_ITEM_STATUS_SUMMARY ls 
inner join DW.REQUESTS_ORDERS_REVENUE_MARGIN_ALL q on q.LINE_ITEM_ID = ls.LINE_ITEM_ID and q.ORDERS = 1 and Q.transaction_date between '10-1-2021' and '10-31-2021'
left join DW.BILLING_TRANSACTIONS bt on bt.LINE_ITEM_ID = ls.LINE_ITEM_ID and bt.TRANSACTION_TIMESTAMP = ls.FIRST_CLOSED_TIMESTAMP and bt.TRANSACTION_MULTIPLIER = 1
left join DW.ORGANIZATION o on o.ORGANIZATION_ID = bt.UPDATED_USER_ID
left join DW.CUSTOMERS c on c.COMPANY_ID = q.customer_id
GROUP BY ls.LINE_ITEM_ID, ls.FIRST_CLOSED_TIMESTAMP, q.channel_code, c.COMPANY_ID, C.COMPANY_NAME, c.LVL1_COMPANY_ID, C.LVL1_COMPANY_NAME, case when bt.updated_user_id is null then 'Auto'
              when o.organization_id is null then 'Auto'
              when bt.updated_user_id= 3 then 'Auto'
              when o.organization_id is not null then 'Manually' else 'ERROR' end
) 
SELECT c.LVL1_COMPANY_ID
,C.LVL1_COMPANY_NAME
,sum(orders) as TOTAL
,sum(CASE when CLSD = 'Auto' then orders else 0 END ) as Orders_Closed_Automatically
,sum(CASE when CLSD = 'Manually' then orders else 0 end ) as Orders_Closed_Manually
,sum(case when c.Channel_Code = 'ePF' then orders else 0 end) / Sum(orders) as EI_Percent
from closed_stats C

GROUP BY c.LVL1_COMPANY_ID, C.LVL1_COMPANY_NAME
order by Orders_Closed_Manually desc
WITH UR;

--5-Supplier Tracking Assigned 
with TN as (
SELECT v.VENDOR_ID,
      c.COMPANY_NAME,
       CASE
          WHEN aa.ACTION_TYPE_ID = 7 then 'PARSER'
          WHEN aa.ACTION_TYPE_ID = 11 then 'RETREVIAL'
         WHEN tn.CREATED_USER_ID = 3 THEN 'System' --cast(aa.ACTION_TYPE_ID as varchar(25))                --system.  EDI/auto generate/reverse looku
            WHEN tn.CREATED_USER_ID = 132392 THEN 'ePV Lite'           --vconfirmed
            when p.id_no IS NOT NULL then 'ADMIN'
            when p.id_no IS  NULL then 'ePV Full'
           
          ELSE '??' --stno.value
       END
          AS Created_User,
       count (*) as count
       --tn.*
  FROM PARTS.SHP_TRACKING_NUMBERS tn
       JOIN parts.sls_line_items sli ON sli.id_no = tn.LINE_ITEM_ID
       JOIN parts.sls_line_researched_vendors v
          ON v.id_no = sli.VENDOR_RESEARCH_ID
       JOIN companies.cmp_companies c on c.company_id = v.VENDOR_ID
       LEFT JOIN CT.PER_PERSONNEL p ON p.id_no = tn.CREATED_USER_ID
       --left join PARTS.SHP_TRACKING_NUMBER_ORIGINS stno on stno.TRACKING_NUMBER_ID = stn.ID_NO
      left join PARTS.SLS_LINE_ITEM_ADMIN_ACTIONS aa on aa.LINE_ITEM_ID = tn.LINE_ITEM_ID  and aa.ACTION_TYPE_ID in (7,11)
 WHERE     tn.CREATED_TIMESTAMP BETWEEN '10/1/2021' AND '10/31/2021'
       AND tn.ACTIVE = 'Y'
       AND tn.SHIPMENT_LEG_ID = 1
       AND tn.DATE_SHIPPED IS NOT NULL
       --and v.VENDOR_ID = 23034
GROUP BY v.VENDOR_ID,c.COMPANY_NAME,tn.CREATED_USER_ID, p.ID_NO, aa.ACTION_TYPE_ID)
--ALL
--select tn.vendor_id, tn.company_name, tn.created_user, sum(tn.count) from tn
--group by tn.vendor_id, tn.company_name, tn.created_user;

--Top Manual
select tn.vendor_id, tn.company_name, tn.created_user, sum(tn.count) from tn
--where tn.Created_user = 'SYSTEM'
--where tn.company_name like 'Alpha%'
group by tn.vendor_id, tn.company_name, tn.created_user
order by sum(tn.count) desc;

