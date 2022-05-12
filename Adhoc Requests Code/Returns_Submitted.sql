Select  distinct lid.line_item_id,
        PO_Date,
        line_item_PO,
        Closed_Date,
        r.created_timestamp,
        r.QUANTITY,
        --tlid.ITEM_COST,
        r.rga_status,
        q.COST
        
FROM    DW.RETURNS_ALL r
        INNER JOIN DW.LINE_ITEM_DETAILS lid on lid.LINE_ITEM_ID = r.line_item_id 
        inner join dw.rorm_all q on q.LINE_ITEM_ID = lid.LINE_ITEM_ID
        --INNER JOIN DW.F_AR_TRANSACTION_LINES tlid on tlid.LINE_ITEM_ID = lid.LINE_ITEM_ID and tlid.ORDERS_IND = 1
where   r.created_timestamp between '1/1/2022' and current_timestamp
        and r.RGA_STATUS = 'Submitted'
REF#
PS PO
Closed Date
Date the Submitted RGA# was created
RTN QNTY
Cost
