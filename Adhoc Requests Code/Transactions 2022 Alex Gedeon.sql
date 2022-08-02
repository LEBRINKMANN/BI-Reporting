Select  Distinct l.LINE_ITEM_ID,
        s.STATUS_CODE,
        tl.ORDER_TYPE,
        l.created_timestamp as Date_Entered,
        l.LINE_ITEM_DESCRIPTION,
        l.PO_DATE,
        tl.CUSTOMER_ID,
        tl.CUSTOMER_NAME,
        tl.LVL1_CUSTOMER_ID,
        c.LVL1_COMPANY_NAME,
        c.STATE,
        c.COMPANY_TYPE_CODE,
        tl.REQUESTED_BY AS REQUESTOR_NAME,
        tl.MODALITY_CODE,
        pc.PRODUCT_CATEGORY_DESCRIPTION AS GROUP_CATEGORY,
        l.CONDITION_CODE,
        v.COMPANY_NAME AS VENDOR_NAME,
        l.OEM_ID,
        o.COMPANY_NAME AS OEM_NAME,
        l.REQUESTED_PART_NUMBER_STRIPPED AS PART_NUMBER,
        l.REQUESTED_QUANTITY,
        max(tl.ITEM_COST) AS ITEM_COST,
        max(tl.ITEM_PRICE) AS ITEM_PRICE,
        max(tl.TOTAL_MARGIN) AS TOTAL_MARGIN,
        max(tl.ITEM_COST) * l.REQUESTED_QUANTITY AS Ext_Cost,
        max(tl.ITEM_PRICE) * l.REQUESTED_QUANTITY AS Ext_Price,
        max(tl.TOTAL_MARGIN) * l.REQUESTED_QUANTITY AS Ext_Margin
        
From    DW.F_AR_TRANSACTION_LINES tl
        INNER JOIN DW.LINE_ITEM_DETAILS l on l.LINE_ITEM_ID = tl.LINE_ITEM_ID
        INNER JOIN DW.SALES_STATUS_CODES s on s.STATUS_ID = l.LINE_ITEM_STATUS_ID
        INNER JOIN DW.CUSTOMERS c on c.COMPANY_ID = l.CUSTOMER_ID
        INNER JOIN DW.PRODUCT_CATEGORIES pc on pc.PRODUCT_CATEGORY_ID = tl.PRODUCT_CATEGORY_ID
        INNER JOIN DW.Vendors v on v.COMPANY_ID = l.vendor_Id
        INNER JOIN DW.OEMS o on o.COMPANY_ID = l.OEM_ID
Where   l.created_timestamp between '4/1/2022' and '6/30/2022'

Group by l.LINE_ITEM_ID,
        s.STATUS_CODE,
        tl.ORDER_TYPE,
        l.created_timestamp,
        l.LINE_ITEM_DESCRIPTION,
        l.Po_date,
        tl.CUSTOMER_ID,
        tl.CUSTOMER_NAME,
        tl.LVL1_CUSTOMER_ID,
        c.LVL1_COMPANY_NAME,
        c.STATE,
        c.COMPANY_TYPE_CODE,
        tl.REQUESTED_BY,
        tl.MODALITY_CODE,
        pc.PRODUCT_CATEGORY_DESCRIPTION,
        l.CONDITION_CODE,
        v.COMPANY_NAME,
        l.OEM_ID,
        o.COMPANY_NAME,
        l.REQUESTED_PART_NUMBER_STRIPPED,
        l.REQUESTED_QUANTITY