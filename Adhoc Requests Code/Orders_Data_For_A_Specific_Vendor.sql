--I’m in need of a report that will help understand the number of transactions/orders we processed on behalf of Welch Allyn using the parameters below:

--•	Date range: January 1,2021 – December 31, 2021
--•	Vendor ID: 24933 (PartsSource)
--•	OEM ID’s: 18519 (Welch), 18430 (Mortara), 18370 (Scale-Tronix), 17838 (Burdick)
--•	Condition Code: OEM Original
--•	Total line ID’s (orders)
--•	Total Qty
--•	Total Revenue (for your records)
--•	Total Spend

Select  tl.*
From    DW.F_AR_TRANSACTION_LINES tl
        inner join DW.LINE_ITEM_DETAILS lid on lid.LINE_ITEM_ID = tl.LINE_ITEM_ID
Where   Transaction_Date Between '1/1/2021' and '12/31/2021'
        and tl.VENDOR_ID = 24933
        and tl.OEM_ID In (18519, 18430, 18370, 17838)
        and lid.CONDITION_CODE = 'OEM ORIG'
        and tl.ORDERS_IND = 1
        
Select  Count(tl.LINE_ITEM_ID) AS Total_Oders,
        Sum(tl.Item_Price) AS Total_Spend,
        Sum(tl.TOTAL_REVENUE) AS Total_Revenue,
        Sum(tl.LINE_QTY) AS Total_Qty
        
From    DW.F_AR_TRANSACTION_LINES tl
        inner join DW.LINE_ITEM_DETAILS lid on lid.LINE_ITEM_ID = tl.LINE_ITEM_ID
Where   Transaction_Date Between '1/1/2021' and '12/31/2021'
        and tl.VENDOR_ID = 24933
        and tl.OEM_ID In (18519, 18430, 18370, 17838)
        and lid.CONDITION_CODE = 'OEM ORIG'
        and tl.ORDERS_IND = 1       