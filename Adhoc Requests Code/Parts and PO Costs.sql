Select tl.Part_Number,
      Avg(tl.Item_Cost) as Avg_Cost,
      Avg(s.SHIP_FREIGHT) as Avg_Ship
From  DW.F_AR_TRANSACTION_LINES tl
      INNER JOIN DW.LINE_ITEM_DETAILS l on l.LINE_ITEM_ID = tl.LINE_ITEM_ID
      INNER JOIN DW.Shipping_Info s on s.LINE_ITEM_ID = l.LINE_ITEM_ID
      
Where tl.LVL1_CUSTOMER_ID = 24105 and tl.ORDERS_IND = 1 and l.PO_DATE is not null and l.PO_DATE between '1/1/2021' and current_timestamp
Group By tl.Part_Number

Select l.GP_PO_Number,
      Avg(tl.Item_Cost) as Avg_Cost
From  DW.F_AR_TRANSACTION_LINES tl
      INNER JOIN DW.LINE_ITEM_DETAILS l on l.LINE_ITEM_ID = tl.LINE_ITEM_ID
Where tl.LVL1_CUSTOMER_ID = 24105 and tl.ORDERS_IND = 1 and l.PO_DATE is not null and l.PO_DATE between '1/1/2021' and current_timestamp
Group By l.GP_PO_Number
------------------------------------------------------------------------------------------------------------------------------------------------

Select l.LINE_ITEM_ID, 
      tl.Part_Number,
      tl.Item_Cost,
      s.SHIP_FREIGHT
From  DW.F_AR_TRANSACTION_LINES tl
      INNER JOIN DW.LINE_ITEM_DETAILS l on l.LINE_ITEM_ID = tl.LINE_ITEM_ID
      INNER JOIN DW.Shipping_Info s on s.LINE_ITEM_ID = l.LINE_ITEM_ID
      
Where tl.LVL1_CUSTOMER_ID = 24105 and tl.ORDERS_IND = 1 and l.PO_DATE is not null and l.PO_DATE between '1/1/2021' and current_timestamp


Select l.line_item_id, 
      l.GP_PO_Number,
      tl.Item_Cost
From  DW.F_AR_TRANSACTION_LINES tl
      INNER JOIN DW.LINE_ITEM_DETAILS l on l.LINE_ITEM_ID = tl.LINE_ITEM_ID
Where tl.LVL1_CUSTOMER_ID = 24105 and tl.ORDERS_IND = 1 and l.PO_DATE is not null and l.PO_DATE between '1/1/2021' and current_timestamp
