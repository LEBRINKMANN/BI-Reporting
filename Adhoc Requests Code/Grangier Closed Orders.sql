select distinct l.LINE_ITEM_ID,
       ld.GP_PO_NUMBER as PS_PO#,
       l.CUSTOMER_NAME,
       sum(l.ITEM_COST) as PO_Amount,
       ld.CLOSED_DATE,
       a.CITY,
       a.ADDRESS_1,
       a.ADDRESS_2,
      a.CITY, a.STATE, a.POSTAL_CODE
      , v.COMPANY_NAME as Vendor
from DW.f_AR_Transaction_Lines l
inner join DW.LINE_ITEM_DETAILS ld on ld.LINE_ITEM_ID = l.LINE_ITEM_ID
inner join DW.COMPANIES c on c.COMPANY_ID = ld.CUSTOMER_ID
inner join DW.SHIPPING_INFO s on s.LINE_ITEM_ID = l.line_item_id
inner join DW.addresses a on a.ADDRESS_ID = s.SHIP_ADDRESS_ID
inner join DW.VENDORS v on v.COMPANY_ID = l.VENDOR_ID
where ld.CLOSED_DATE >= '5/1/2022' and v.COMPANY_ID = 18645 --and c.COMPANY_TYPE_CODE = 'PERSONAL'
group by l.LINE_ITEM_ID,
       ld.GP_PO_NUMBER,
       l.CUSTOMER_NAME,
       ld.CLOSED_DATE,
       a.CITY,
       a.ADDRESS_1,
       a.ADDRESS_2,
      a.CITY, a.STATE, a.POSTAL_CODE, v.COMPANY_NAME 