
--Overnight - Awaiting Shipment
Select 'Overnight - Awaiting Shipment', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
       join DW.SHIPPING_INFO s On lid.LINE_ITEM_ID = s.LINE_ITEM_ID
       join DW.Ship_Methods m On s.SHIPPING_METHOD = m.SHIPPING_METHOD and m.TRANSIT_DAYS = 1
       left join DW.TRACKING_NUMBERS t On lid.LINE_ITEM_ID = t.LINE_ITEM_ID  and t.SHIPMENT_LEG_ID = 1
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >=  current_timestamp - 3
       and c.Company_Id in (119, 60891, 4782) 
       and t.LINE_ITEM_ID is null
Group By c.LVL1_COMPANY_NAME
with ur;

--Overnight/Priority - Backordered w/ out ESD
Select 'Overnight/Priority - Backordered w/ out ESD', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
       join DW.SHIPPING_INFO s On lid.LINE_ITEM_ID = s.LINE_ITEM_ID
       join DW.Ship_Methods m On s.SHIPPING_METHOD = m.SHIPPING_METHOD and m.TRANSIT_DAYS in (1,2,3)
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >=  current_timestamp - 3
       and lid.ESTIMATED_SHIPPING_DATE is null 
       and lid.ESD_DESCRIPTION = 'Backordered'
       and c.Company_Id in (119, 60891, 4782)
Group By c.LVL1_COMPANY_NAME
with ur;

--Overnight/Priority - Backordered w/ ESD
Select 'Overnight/Priority - Backordered w/ ESD', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
       join DW.SHIPPING_INFO s On lid.LINE_ITEM_ID = s.LINE_ITEM_ID
       join DW.Ship_Methods m On s.SHIPPING_METHOD = m.SHIPPING_METHOD and m.TRANSIT_DAYS in (1,2,3)
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >=  current_timestamp - 3
       and lid.ESTIMATED_SHIPPING_DATE is not null 
       and lid.ESD_DESCRIPTION = 'Backordered'
       and lid.LINE_ITEM_STATUS_ID = 25
       and c.Company_Id in (119, 60891, 4782)
Group By c.LVL1_COMPANY_NAME
with ur;

--Priority - On Hold
Select 'Priority - On Hold', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
       join DW.SHIPPING_INFO s On lid.LINE_ITEM_ID = s.LINE_ITEM_ID
       join DW.Ship_Methods m On s.SHIPPING_METHOD = m.SHIPPING_METHOD and m.TRANSIT_DAYS in (1,2,3)
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >=  current_timestamp - 3
       and c.CREDIT_HOLD = 'Y'
       and c.Company_Id in (119, 60891, 4782)
Group By c.LVL1_COMPANY_NAME
with ur;

--Priority - Orders Not Confirmed
Select 'Priority - Orders Not Confirmed', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
       join DW.SHIPPING_INFO s On lid.LINE_ITEM_ID = s.LINE_ITEM_ID
       join DW.Ship_Methods m On s.SHIPPING_METHOD = m.SHIPPING_METHOD and m.TRANSIT_DAYS in (1,2,3)
       join DW.TRACKING_NUMBERS t On lid.LINE_ITEM_ID = t.LINE_ITEM_ID  and t.SHIPMENT_LEG_ID = 1
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >=  current_timestamp - 3
       and t.DATE_CONFIRMED is null
       and c.Company_Id in (119, 60891, 4782)
Group By c.LVL1_COMPANY_NAME
with ur;

--Priority - Sourcing awaiting response
Select 'Priority - Sourcing awaiting response', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
       join DW.SHIPPING_INFO s On lid.LINE_ITEM_ID = s.LINE_ITEM_ID
       join DW.Ship_Methods m On s.SHIPPING_METHOD = m.SHIPPING_METHOD and m.TRANSIT_DAYS in (1,2,3)
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >=  current_timestamp - 3
       and c.Company_Id in (119, 60891, 4782)
       and lid.LINE_ITEM_STATUS_ID in (1,2)
Group By c.LVL1_COMPANY_NAME
with ur;

--Critical Item - Not Ordered
Select 'Priority - Sourcing awaiting response', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >=  current_timestamp - 3
       and lid.LINE_ITEM_STATUS_ID = 7
       and lid.URGENCY_CODE = 'STAT'
       and c.Company_Id in (119, 60891, 4782)
Group By c.LVL1_COMPANY_NAME
with ur;

--Critical Item - Awaiting Sourcing
Select 'Priority - Sourcing awaiting response', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >=  current_timestamp - 3
       and lid.LINE_ITEM_STATUS_ID in (1,2)
       and lid.URGENCY_CODE = 'STAT'
       and c.Company_Id in (119, 60891, 4782)
Group By c.LVL1_COMPANY_NAME
with ur;

--Critical Item - Awaiting Quote
Select 'Critical Item - Awaiting Quote', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >=  current_timestamp - 3
       and lid.LINE_ITEM_STATUS_ID = 3
       and lid.MANUAL_RESEARCH = 1
       and lid.URGENCY_CODE = 'STAT'
       and c.Company_Id in (119, 60891, 4782)
Group By c.LVL1_COMPANY_NAME
with ur;

--Change in Estimated Ship Date
Select 'Change in Estimated Ship Date', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
       join (select count(updated_timestamp) as updated_ship_count, LINE_ITEM_ID 
             FROM DW.ESTIMATED_SHIP_INFO 
             where ESD <> updated_timestamp
             group by line_item_id) ESD on ESD.line_Item_Id = lid.LINE_ITEM_ID and updated_ship_count > 1
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >= current_timestamp - 3
       and c.Company_Id in (119, 60891, 4782)
Group By c.LVL1_COMPANY_NAME
with ur;

--Order didn’t ship on schedule / past ESD
Select 'Order didn’t ship on schedule / past ESD', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >= current_timestamp - 3
       and (current_timestamp - 1 > lid.ESTIMATED_SHIPPING_DATE or current_timestamp - 2 > lid.ESTIMATED_SHIPPING_DATE or current_timestamp - 3 > lid.ESTIMATED_SHIPPING_DATE)
       and c.Company_Id in (119, 60891, 4782)
Group By c.LVL1_COMPANY_NAME
with ur;


--Not Ordered Close to Cutoff
Select 'Not Ordered Close to Cutoff', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
       join DW.Vendors v on lid.VENDOR_ID = v.COMPANY_ID
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >= current_timestamp - 3
       and lid.LINE_ITEM_STATUS_ID = 25
       and lid.SMART_ORDER_CONF = 0
       and Time(coalesce(v.VEND_CUTOFF_EST, '4:00:00')) - Time(Current_timestamp) < 23000
       and c.Company_Id in (119, 60891, 4782)
Group By c.LVL1_COMPANY_NAME
with ur;

--Order missed a cutoff time
Select 'Order missed a cutoff time', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
       join DW.Vendors v on lid.VENDOR_ID = v.COMPANY_ID
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >= current_timestamp - 3
       and lid.LINE_ITEM_STATUS_ID = 25
       and lid.SMART_ORDER_CONF = 0
       and Time(Current_timestamp) > Time(coalesce(v.VEND_CUTOFF_EST, '4:00:00'))
       and c.Company_Id in (119, 60891, 4782)
Group By c.LVL1_COMPANY_NAME
with ur;

--Item - Backordered w/ out ESD
Select 'Item - Backordered w/ out ESD', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >=  current_timestamp - 3
       and lid.ESTIMATED_SHIPPING_DATE is null 
       and lid.ESD_DESCRIPTION = 'Backordered'
       and lid.LINE_ITEM_STATUS_ID = 25
       and c.Company_Id in (119, 60891, 4782)
Group By c.LVL1_COMPANY_NAME
with ur;


--Item - Backordered w/ ESD
Select 'Item - Backordered w/ out ESD', c.LVL1_COMPANY_NAME, Count(distinct lid.line_item_id) as Status_Count
From   Dw.Line_Item_Details lid
       join DW.LINE_ITEM_STATUS_SUMMARY SS On SS.LINE_ITEM_ID = lid.LINE_ITEM_ID 
       join DW.CUSTOMERS c on c.COMPANY_ID = lid.CUSTOMER_ID 
where  ss.last_ordered_timestamp is not null 
       and SS.LAST_ORDERED_TIMESTAMP >=  current_timestamp - 3
       and lid.ESTIMATED_SHIPPING_DATE is not null 
       and lid.ESD_DESCRIPTION = 'Backordered'
       and lid.LINE_ITEM_STATUS_ID = 25
       and c.Company_Id in (119, 60891, 4782)
Group By c.LVL1_COMPANY_NAME
with ur;
