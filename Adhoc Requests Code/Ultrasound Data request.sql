select  tlid.LINE_ITEM_ID, tlid.ORDER_ID,	tlid.STATUS,	tlid.TRANSACTION_DATE,	tlid.LINE_CREATION_DATE,	tlid.ORDER_CHANNEL,	tlid.PART_NUMBER,
        tlid.ITEM_DESCRIPTON,	tlid.MODALITY_DESCRIPTION,	tlid.ORDER_TYPE,	tlid.LINE_QTY,	tlid.RETURN_QTY,	tlid.ITEM_COST,	 tlid.ITEM_PRICE,
        tlid.OEM_PRICE,	 tlid.TOTAL_REVENUE,	 tlid.TOTAL_MARGIN, 	tlid.EQUIPMENT_NUMBER,	tlid.EQUIPMENT_SERIAL_NUMBER,
        tlid.CATALOG,	tlid.CUSTOMER_NAME,	tlid.VENDOR_NAME,	tlid.ACCOUNT_OWNER,	tlid.REQUESTED_BY,	tlid.CREATED_BY,	tlid.UPDATED_UNAME,
        tlid.CLOSED_TYPE,	tlid.BACKLOG_IND,	tlid.BACKORDER_IND,	tlid.ORDERS_IND,	tlid.REQUESTS_IND,	tlid.SMARTPRICE_IND,	tlid.REPAIR_IND,
        tlid.SERVICE_IND,	tlid.LOANER_IND,	tlid.MANUAL_RESEARCH_IND,	tlid.CPRO_IND,	tlid.SMART_PRICE_FLAG,	tlid.SMART_ORDER_PO,	tlid.SMART_SHIP_CONFIRM,	tlid.SUBSCRIPTION_NAME													

from    dw.f_ar_transaction_lines tlid
        inner join DW.LINE_ITEM_DETAILS lid on lid.LINE_ITEM_ID = tlid.LINE_ITEM_ID
where   tlid.modality_code in ('ULTRASOUND PROBES', 'ULTRASOUND')
      --and lid.REPAIR_IND = 1
      --and lid.RETURN_REQUIRED = 'Y'
      --and lid.condition_code like 'OEM%'
      and lid.condition_code = 'REFURB'
      --and tlid.REQUESTS_IND = 1
      and year(tlid.transaction_date) = '2021'
--      and tlid.line_item_id not in (select tlid.line_item_id 
--                                    from dw.f_ar_transaction_lines tlid
--                                    where tlid.modality_code in ('ULTRASOUND PROBES', 'ULTRASOUND')
--                                          and tlid.Orders_ind = 1
--                                          and year(tlid.transaction_date) = '2021')
with ur;

