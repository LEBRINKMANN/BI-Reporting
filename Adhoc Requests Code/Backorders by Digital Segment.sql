--select reporting_region, c.* from DW.CUSTOMERS c
--where LVL1_COMPANY_ID in (38451,53610,53611,145379) 
--
--select distinct c.LVL1_COMPANY_ID, bs.BUDGET_SEGMENT from DW.BUDGET_SEGMENTS bs
--inner join DW.LINE_ITEM_DETAILS l on l.line_item_id = bs.LINE_ITEM_ID
--inner join dw.customers c on l.CUSTOMER_ID = c.COMPANY_ID
--where c.LVL1_COMPANY_ID in (263,3681,9140,24089,29404,27612)
----in (38451,53610,53611,145379) 
--
--from dw.customers c 
--left join DW.ENTERPRISE_DETAILS_SITES e on e.parent_id = c.COMPANY_ID
--
--select *
--from dw.customers c 
--left join DW.ENTERPRISE_DETAILS_SITES e on e.parent_id = c.COMPANY_ID
--where c.company_type_code like '%ISO%' and e.parent_id is not null
--
--
--select distinct c.LVL1_COMPANY_ID, e.PARENT_ID
--from dw.customers c 
--left join DW.ENTERPRISE_DETAILS_SITES e on e.parent_id = c.COMPANY_ID
--where c.LVL1_COMPANY_ID in (263,3681,9140,24089,29404,27612) 
---------------------------------------------------------------------------------------------------------------------------------------

--needed columns
--Modality, business segment, account name, order #, revenue of backordered product(s), time item(s) have been on backorder


/*active PRO accounts*/

with Subscription
as (
select  parent_id,
        site_id, 
        program_name, 
        start_date, 
        end_date
from    dw.enterprise_details_sites
where   program_type like 'S%' and( end_date is null or end_date >= current_timestamp)
)  
 

select  distinct l.line_item_id,
        case  when c.lvl1_company_id in (38451,53610,53611,145379) then 'GUEST'
              when c.lvl1_company_id in (263,3681,9140,24089,29404,27612) THEN 'NATIONAL'
              when c.lvl1_company_id = 119 then 'ENTERPRISE - ISO'
              when sub.parent_id is not null then 'ENTERPRISE - PROGRAM'
              when c.lvl1_company_id = 37810 then 'GOVERNMENT'
              when c.company_type_code like '%ISO' then 'ISO'
              else 'TRX' end as Business_Segment,
        tlid.modality_code,
        sub.program_name,
        tlid.ORDER_ID,
        tlid.TOTAL_REVENUE,
        tlid.TRANSACTION_DATE,
        l.BACKORDER_SHIP_DATE
from    dw.customers c 
        inner join dw.f_AR_Transaction_Lines tlid on tlid.lvl1_Customer_Id = c.LVL1_COMPANY_ID
        inner join DW.LINE_ITEM_DETAILS l on l.LINE_ITEM_ID = tlid.LINE_ITEM_ID
        left join subscription as sub on sub.parent_id = c.lvl1_company_id  and (sub.site_id is null or sub.site_id = c.company_id) 
where   tlid.Backorder_ind = 1  and tlid.TRANSACTION_DATE >= '4/1/2022'



