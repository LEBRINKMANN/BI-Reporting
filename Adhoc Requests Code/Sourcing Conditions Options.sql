select line_item_id, count(case when v.RESEARCH_TYPE_CODE = 'MR' then 1 else null end) as lines_of_manual
, count(distinct(case when v.RESULT_CODE in ('HP','EHP') then condition_code else null end)) as Num_conditions_purchaseable
, count(distinct(condition_code)) as Num_conditions_Total
,count(line_item_id) as Total_lines
from DW.VENDOR_RESEARCH v
group by line_item_id
/*having count(distinct(case when v.RESULT_CODE in ('HP','EHP') then condition_code else null end)) >4*/
order by count(distinct(case when v.RESULT_CODE in ('HP','EHP') then condition_code else null end)) desc


--Select max(FIRST_REQRTN_TIMESTAMP) From DW.LINE_ITEM_STATUS_SUMMARY

--Purchasable option is when Vendor_Research.Result_Code = EHP, EP
--Manually sourced is when Vendor_Reasearch.Research_Type_Code = MR
--conditions is Vendor_Research.condition_code
--unit cost is Item_Cost on F_Ar_Transaction_Lines

--Average number of conditions  with a purchasable option when manually sourced over the last 36 months grouped quarterly 

Select  v.LINE_ITEM_ID,
        tl.TRANSACTION_DATE,
        tl.MODALITY_CODE, 
        tl.LVL1_CUSTOMER_ID AS Parent_Id,
        tl.customer_name AS Customer,
        pc.PRODUCT_CATEGORY_DESCRIPTION AS Product_Category,
        tl.ITEM_COST,
        Case when tl.ITEM_COST < '500.00' Then 'Under $500'
                   when tl.ITEM_COST Between '500.00' and '1000.00' Then '$500-$1k'
                   when tl.ITEM_COST Between '1000.01' and '5000.00' Then '$1k-$5k'
                   when tl.ITEM_COST Between '5000.01' and '10000.00' Then '$5k-$10k'
                   when tl.ITEM_COST > '10000.00' then 'Over $10k'
        End AS Cost_Buckets,
        Case when v.RESULT_CODE in ('HP', 'EHP') Then 'Purchasable' else 'Not Purchasable' End AS Result_Code_State,
        Count(v.condition_code) Condition_code_Count
From    DW.VENDOR_RESEARCH v
        inner join DW.F_AR_TRANSACTION_LINES tl on tl.LINE_ITEM_ID = v.LINE_ITEM_ID
        inner join DW.PRODUCT_CATEGORIES pc on pc.PRODUCT_CATEGORY_ID = tl.PRODUCT_CATEGORY_ID
Where   v.research_type_code = 'MR'
        and Month(tl.TRANSACTION_DATE) > Month(current_timestamp) - 36
        and tl.ORDERS_IND = 1 and tl.REPAIR_IND = 0 and tl.SERVICE_IND = 0
group by  v.LINE_ITEM_ID, tl.ITEM_COST, tl.TRANSACTION_DATE,
          tl.MODALITY_CODE, tl.LVL1_CUSTOMER_ID,
          tl.customer_name,
          pc.PRODUCT_CATEGORY_DESCRIPTION,
          Case when tl.ITEM_COST < '500.00' Then 'Under $500'
               when tl.ITEM_COST Between '500.00' and '1000.00' Then '$500-$1k'
               when tl.ITEM_COST Between '1000.01' and '5000.00' Then '$1k-$5k'
               when tl.ITEM_COST Between '5000.01' and '10000.00' Then '$5k-$10k'
               when tl.ITEM_COST > '10000.00' then 'Over $10k' End,
         Case when v.RESULT_CODE in ('HP', 'EHP') Then 'Purchasable' else 'Not Purchasable' End
