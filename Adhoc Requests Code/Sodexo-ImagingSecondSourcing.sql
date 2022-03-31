Select  Sum(Case when tlid.REPAIR_IND = 1 Then tlid.TOTAL_REVENUE Else 0 End) as Total_Repairs_Revenue,
        Sum(Case when tlid.SERVICE_IND = 1 Then tlid.TOTAL_REVENUE Else 0 End) as Total_Sevices_Revenue,
        Sum(Case when tlid.REPAIR_IND = 0 and tlid.SERVICE_IND = 0 Then tlid.Total_Revenue Else 0 End) as Total_Parts_Revenue,
        --Sum(Case when lid.RETURN_REQUIRED = 'Y' Then tlid.TOTAL_REVENUE Else 0 End) as Total_Returns_value, -- don't think this is correct
        Sum(tlid.TOTAL_REVENUE) as Total_Revenue,
        Sum(tlid.ORDERS_IND) as Total_Orders,
        Sum(tlid.REQUESTS_IND) as Total_Requests
FROM    DW.F_AR_TRANSACTION_LINES tlid
        inner join DW.line_Item_details lid on lid.LINE_ITEM_ID = tlid.LINE_ITEM_ID
        INNER JOIN DW.PRODUCT_CATEGORIES pc on pc.PRODUCT_CATEGORY_ID = lid.PRODUCT_CATEGORY_ID
        INNER JOIN DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID
Where   Year(tlid.TRANSACTION_DATE) > 2021
        --tlid.TRANSACTION_DATE > '9/1/2021'
        and pc.GROUP_CATEGORY = 'Imaging'
        and (tlid.ORDERS_IND = 1 or tlid.REQUESTS_IND = 1)
        --and tlid.ORDERS_IND = 1
        --and tlid.REQUESTS_IND = 1
        and c.LVL1_COMPANY_ID = 119 

----------------------------------------------------------------------------------------------------------

Select  tlid.LINE_ITEM_ID, tlid.ORDERS_IND, tlid.REQUESTS_IND,	
        tlid.ORDER_ID, tlid.STATUS	, tlid.TRANSACTION_DATE	, tlid.ORDER_CHANNEL,	
        tlid.PART_NUMBER	, tlid.ITEM_DESCRIPTON	, tlid.MODALITY_CODE,	
        tlid.MODALITY_DESCRIPTION	, tlid.ORDER_TYPE	, tlid.LINE_QTY	, tlid.RETURN_QTY	,
        tlid.ITEM_COST	 , tlid.ITEM_PRICE 	 , tlid.OEM_PRICE 	 , 
        tlid.TOTAL_REVENUE 	 , tlid.TOTAL_MARGIN 	, tlid.EQUIPMENT_NUMBER	, tlid.EQUIPMENT_SERIAL_NUMBER,
        tlid.CATALOG	, tlid.CUSTOMER_NAME	, tlid.VENDOR_NAME	, tlid.ACCOUNT_OWNER	, 
        tlid.REQUESTED_BY	, tlid.CREATED_BY	, tlid.CREATED_UNAME	, tlid.UPDATED_UNAME,	tlid.CLOSED_TYPE	,
        tlid.BACKLOG_IND	, tlid.BACKORDER_IND	, tlid.SMARTPRICE_IND,	tlid.REPAIR_IND	, 
        tlid.SERVICE_IND	, tlid.LOANER_IND	, tlid.MANUAL_RESEARCH_IND	, tlid.CPRO_IND	,
        tlid.SMART_PRICE_FLAG	, tlid.SMART_ORDER_PO	, tlid.SMART_SHIP_CONFIRM	, 
        tlid.TRANSACTION_TIMESTAMP	, lid.CONDITION_CODE	, lid.REQUESTED_QUANTITY	,
        tn.DATE_SHIPPED	, lid.SOURCED_DATE	, lid.PO_DATE	, nsr.NOSALE_REASON_DESCRIPTION	, 
        pc.PRODUCT_CATEGORY_DESCRIPTION	, v.City as VENDOR_CITY	, v.state as VENDOR_STATE

FROM    DW.F_AR_TRANSACTION_LINES tlid
        inner join DW.line_Item_details lid on lid.LINE_ITEM_ID = tlid.LINE_ITEM_ID
        INNER JOIN DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID
        INNER JOIN DW.PRODUCT_CATEGORIES pc on pc.PRODUCT_CATEGORY_ID = lid.PRODUCT_CATEGORY_ID
        INNER JOIN DW.VENDORS v on lid.VENDOR_ID = v.COMPANY_ID
        LEFT JOIN DW.NOSALE_REASONS nsr on nsr.NOSALE_REASON_ID = lid.NOSALE_REASON_ID
        LEFT JOIN DW.TRACKING_NUMBERS tn on tn.LINE_ITEM_ID = lid.LINE_ITEM_ID
Where   tlid.TRANSACTION_DATE > '9/1/2021'
        and pc.GROUP_CATEGORY = 'Imaging'
        and (tlid.ORDERS_IND = 1 or tlid.REQUESTS_IND = 1)
        and c.LVL1_COMPANY_ID = 119 
        
        
----------------------------------------------------------------------------------------------------------------
--Select  Distinct rorm.TRANSACTION_DATE, 
--        rorm.ORDER_ID, 
--        lid.WORK_ORDER_NUMBER,
--        rorm.LINE_ITEM_ID, 
--        sc.STATUS_ID, 
--        pc.GROUP_CATEGORY,
--        sc.DESCRIPTION, 
--        tn.DATE_SHIPPED, 
--        lid.SOURCED_DATE, 
--        lid.PO_DATE, 
--        i.PART_NUMBER, 
--        i.DESCRIPTION as Item_Description, 
--        lid.CONDITION_CODE, 
--        lid.Requested_Quantity, 
--        ip.Outright_Price,
--        c.COMPANY_NAME, 
--        c.CITY as Customer_City, 
--        c.state as Customer_State, 
--        rorm.SOURCED_BY_ID, 
--        v.COMPANY_NAME as Supplier, 
--        v.CITY as Supplier_City, 
--        v.state as Supplier_State, 
--        nsr.NOSALE_REASON_DESCRIPTION, 
--        --te.TECH_ENGINEER, 
--        cr.FIRST_NAME,
--        cr.LAST_NAME,
--        m.MODALITY_DESCRIPTION,
--        lid.ESTIMATED_SHIPPING_DATE
--from    DW.RORM_All rorm
--        INNER JOIN DW.LINE_ITEM_DETAILS lid on lid.LINE_ITEM_ID = rorm.LINE_ITEM_ID
--        INNER JOIN DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID
--        INNER JOIN DW.SALES_STATUS_CODES sc on sc.STATUS_ID = rorm.STATUS_ID
--        INNER JOIN DW.PRODUCT_CATEGORIES pc on pc.PRODUCT_CATEGORY_ID = rorm.PRODUCT_CATEGORY_ID
--        INNER JOIN DW.Pim_Item_Prices ip on ip.OEM_ITEM_NUMBER = lid.OEM_ITEM_NUMBER
--        INNER JOIN DW.VENDORS v on lid.VENDOR_ID = v.COMPANY_ID
--        LEFT JOIN DW.PIM_ITEMS i on i.ITEM_NUMBER = ip.OEM_ITEM_NUMBER
--        LEFT JOIN DW.TRACKING_NUMBERS tn on tn.LINE_ITEM_ID = lid.LINE_ITEM_ID
--        --LEFT JOIN DW.F_COMPANY_TECH_ENGINEERS te on te.TE_ID = 
--        LEFT JOIN DW.Company_Requestors cr on cr.REQUESTOR_ID = rorm.REQUESTOR_ID
--        LEFT JOIN DW.MODALITIES m on m.MODALITY_ID = lid.MODALITY_ID
--        LEFT JOIN DW.NOSALE_REASONS nsr on nsr.NOSALE_REASON_ID = rorm.NOSALE_REASON_ID
--Where   Transaction_Date >= '9/1/2021'
--        and c.LVL1_COMPANY_ID = 119 
--        and sc.STATUS_ID <> 7
--        and pc.GROUP_CATEGORY = 'Imaging'
--with ur;        