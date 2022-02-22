proc sql;
connect to DB2 (database=PFPROD user=dwuser password=sasisgreat);
create table work.Open_Orders as
<<<<<<< HEAD
select *
from connection to DB2
(
/*with  max_time as
(select SLICON.LINE_ITEM_ID
,max(SLICON.CREATED_TIMESTAMP) as time_stamp
from PARTS.SLS_LINE_ITEM_CONFIRMATIONS SLICON
group by SLICON.LINE_ITEM_ID),*/
 with max_time_PN as
(select SLIN.LINE_ITEM_ID
,max(SLIN.CREATED_TIMESTAMP) as time_stamp
from PARTS.SLS_LINE_ITEM_NOTES   SLIN
group by SLIN.LINE_ITEM_ID ),

ADDRESS_COMBINED AS
(SELECT
SDL.LINE_ITEM_ID
 ,SHP.PRIORITY_CODE
FROM PARTS.SLS_SHIPPING_DOCUMENT_LINES SDL
LEFT JOIN PARTS.SLS_SHIPPING_DOCUMENTS SSD ON SSD.ID_NO = SDL.SHIPPING_DOCUMENT_ID
LEFT JOIN CT.CT_SHIP_PRIORITIES SHP ON SSD.SHIP_PRIORITY_ID = SHP.PRIORITY_ID
)
, PURCHASE_LINES AS
(
SELECT
PL1.LINE_ITEM_ID
,SHP.PRIORITY_CODE
FROM PARTS.SLS_PURCHASE_LINES  PL1
LEFT JOIN PARTS.SLS_PURCHASE_LINES  PL2 ON PL1.LINE_ITEM_ID = PL2.LINE_ITEM_ID AND PL1.CREATED_TIMESTAMP < PL2.CREATED_TIMESTAMP AND PL2.STATUS_ID <> 5
LEFT JOIN CT.CT_SHIP_PRIORITIES SHP ON pl1.SHIP_PRIORITY_ID = SHP.PRIORITY_ID
WHERE PL1.STATUS_ID <> 5  AND PL2.CREATED_TIMESTAMP IS NULL

)
select  

	STATUS_CODE as Status
	,line_item_po AS CUSTOMER_PO
	,sli.id_no as REF_NUMBER
	,sli.ORDER_ID
	, TRIM(R.FIRST_NAME)||' '||R.LAST_NAME        AS REQUESTOR_NAME
	,  cmpa.CITY
,  cmpa.STATE
		/*,c.COMPANY_NAME AS SITE_NAME*/
		,o.company_name as OEM
	,coalesce(SLR.REPLACEMENT_PART_NUMBER_STRIPPED,SLI.PART_NUMBER_STRIPPED) as PART_NUMBER
	  , INTEGER(sli.Quantity+sli.Return_Quantity) as REQUESTED_QTY

	, SLI.DESCRIPTION AS Product_Description 
	,MODALITY_CODE 
	  , COALESCE(SPL.PRIORITY_CODE, AD.PRIORITY_CODE)  AS SHIPPING_METHOD
  ,date(sli.CLOSED_DATE) as Customer_Order_Date

 
  /*,sli.CREATED_TIMESTAMP as CREATED_DATE*/
  /*,timestampdiff(4,sli.CLOSED_DATE-sli.CREATED_TIMESTAMP) aS SPEED_TO_CLOSED*/




,esd.ESD AS ESD
,esd.DESCRIPTION as ESD_DESCRIPTION
, time(CAST( (CASE WHEN NOT CMP.SHIP_CUTOFF_TIME_UTC IS NULL THEN '2013-05-01-'||REPLACE(CMP.SHIP_CUTOFF_TIME_UTC,':', '.')||'.00' END) AS TIMESTAMP)-5 HOURS) as Vendor_Cut_off

 , SLR.LEAD_TIME_DAYS AS LEAD_TIME_DAYS

/*,pp.CONFIRMATION_NOTES*/
/*,CN.NOTE AS GENERAL_NOTES*/
/*,LOCALE_TIME_ZONE*/

,CONDITION_CODE

	from PARTS.SLS_LINE_ITEMS  as  sli  
left join parts.sls_orders slo on slo.id_NO= sli.order_id
    left join COMPANIES.COMPANIES_HIERARCHY_V c on c.COMPANY_ID = slo.COMPANY_ID and c.CUSTOMER_IND ='Y'
  
   left join COMPANIES.COMPANIES_HIERARCHY_V o on o.COMPANY_ID = sli.oem_ID and o.oem_IND ='Y'

		left join CT.CT_MODALITY_CODES m on m.modality_id = SLI.modality_id 
	  LEFT JOIN PARTS.SLS_LINE_RESEARCHED_VENDORS SLR ON SLI.VENDOR_RESEARCH_ID = SLR.ID_NO
        left join COMPANIES.COMPANIES_HIERARCHY_V v on v.COMPANY_ID = slr.VENDOR_ID and v.Vendor_IND ='Y'
        JOIN COMPANIES.CMP_COMPANIES CMP ON V.COMPANY_ID = CMP.COMPANY_ID
		Left join COMPANIES.CMP_CONTACTS r on r.CONTACT_ID= slo.requestor_id  

    left join (Select es.LINE_ITEM_ID, CH.DESCRIPTION , es.ESD, o.USER_NAME
from PARTS.ESTIMATED_SHIP_DATE es 
left join CT.ESD_CHANGE_REASONS CH ON CH.REASON_ID = es.REASON_ID 
left join CT.PER_PERSONNEL  o on o.ID_NO  = es.CREATED_USER_ID
wHERE ES.ACTIVE ='Y') esd on esd.LINE_ITEM_ID = sli.id_no
left join ADDRESS_COMBINED ad on ad.LINE_ITEM_ID = sli.id_no
LEFT JOIN PURCHASE_LINES SPL ON sli.id_no  = SPL.LINE_ITEM_ID

/*left join (select SLICON.LINE_ITEM_ID
, PP.USER_NAME
, slicon.CONFIRMATION_NOTES
from PARTS.SLS_LINE_ITEM_CONFIRMATIONS SLICON
LEFT JOIN CT.PER_PERSONNEL PP ON SLICON.CONFIRMED_BY_ID = PP.ID_NO
inner join max_time mt on mt.LINE_ITEM_ID = SLICON.LINE_ITEM_ID and mt.TIME_STAMP = SLICON.CREATED_TIMESTAMP) pp on pp.line_item_id = sli.id_no*/
left join (select SLIN.LINE_ITEM_ID, PP.USER_NAME, SLIN.NOTE
from PARTS.SLS_LINE_ITEM_NOTES SLIN
LEFT JOIN CT.PER_PERSONNEL PP ON SLIN.UPDATED_USER_ID = PP.ID_NO
inner join max_time_PN mt on mt.LINE_ITEM_ID = SLIN.LINE_ITEM_ID and mt.TIME_STAMP = SLIN.CREATED_TIMESTAMP) CN on CN.line_item_id = sli.id_no
   LEFT JOIN CT.CT_INV_ITEM_CONDITION_CODES COND ON SLR.CONDITION_ID = COND.CONDITION_ID
left join ct.CT_SLS_STATUS_CODES sc on sc.status_id = sli.status_id 
left join PARTS.SLS_LINE_ITEM_CONFIRMATIONS vo on vo.line_item_id = sli.id_no
left join CT.CT_MODALITY_PRODTYPE_RELATIONS MPR on MPR.MODALITY_ID = SLI.MODALITY_ID AND MPR.PRODUCT_TYPE_ID = SLI.CLASS_ID
	Left Join ct.CT_PRODUCT_SUB_CATEGORIES p on p.PRODUCT_SUB_CATEGORY_ID = MPR.PRODUCT_SUBCATEGORY_ID
left join  PARTS.SLS_SHIPPING_DOCUMENT_LINES SDL on SDL.LINE_ITEM_ID =  sli.id_no
LEFT JOIN PARTS.SLS_SHIPPING_DOCUMENTS SSD ON SSD.ID_NO = SDL.SHIPPING_DOCUMENT_ID
left join    COMPANIES.CMP_ADDRESSES cmpa on cmpa.address_id = ssd.SHIP_ADDRESS_ID 
where c.lvl1_COMPANY_ID =119 and sli.status_id not in  (8,5,13)
=======

SELECT *
FROM   Connection to DB2
(

 With max_time_PN as
(SELECT SLIN.LINE_ITEM_ID
        ,max(SLIN.CREATED_TIMESTAMP) as time_stamp
FROM    PARTS.SLS_LINE_ITEM_NOTES   SLIN
GROUP BY SLIN.LINE_ITEM_ID 
)
,ADDRESS_COMBINED AS
(SELECT SDL.LINE_ITEM_ID
        ,SHP.PRIORITY_CODE
FROM    PARTS.SLS_SHIPPING_DOCUMENT_LINES SDL
        LEFT JOIN PARTS.SLS_SHIPPING_DOCUMENTS SSD ON SSD.ID_NO = SDL.SHIPPING_DOCUMENT_ID
        LEFT JOIN CT.CT_SHIP_PRIORITIES SHP ON SSD.SHIP_PRIORITY_ID = SHP.PRIORITY_ID 
)
,PURCHASE_LINES AS
(SELECT PL1.LINE_ITEM_ID
        ,SHP.PRIORITY_CODE
FROM    PARTS.SLS_PURCHASE_LINES  PL1
        LEFT JOIN PARTS.SLS_PURCHASE_LINES  PL2 ON PL1.LINE_ITEM_ID = PL2.LINE_ITEM_ID AND PL1.CREATED_TIMESTAMP < PL2.CREATED_TIMESTAMP AND PL2.STATUS_ID <> 5
        LEFT JOIN CT.CT_SHIP_PRIORITIES SHP ON pl1.SHIP_PRIORITY_ID = SHP.PRIORITY_ID
WHERE PL1.STATUS_ID <> 5  AND PL2.CREATED_TIMESTAMP IS NULL
)

SELECT  STATUS_CODE as Status
      	,line_item_po AS CUSTOMER_PO
      	,sli.id_no as REF_NUMBER
      	,sli.ORDER_ID
      	,TRIM(R.FIRST_NAME)||' '||R.LAST_NAME AS REQUESTOR_NAME
      	,cmpa.CITY
        ,cmpa.STATE
      	,o.company_name as OEM
      	,coalesce(SLR.REPLACEMENT_PART_NUMBER_STRIPPED,SLI.PART_NUMBER_STRIPPED) as PART_NUMBER
      	,INTEGER(sli.Quantity+sli.Return_Quantity) as REQUESTED_QTY
      	,SLI.DESCRIPTION AS Product_Description 
      	,MODALITY_CODE 
      	,COALESCE(SPL.PRIORITY_CODE, AD.PRIORITY_CODE)  AS SHIPPING_METHOD
        ,date(sli.CLOSED_DATE) as Customer_Order_Date
        /*,sli.CREATED_TIMESTAMP as CREATED_DATE*/
        /*,timestampdiff(4,sli.CLOSED_DATE-sli.CREATED_TIMESTAMP) aS SPEED_TO_CLOSED*/
        ,esd.ESD AS ESD
        ,esd.DESCRIPTION as ESD_DESCRIPTION
        ,time(CAST( (CASE WHEN NOT CMP.SHIP_CUTOFF_TIME_UTC IS NULL THEN '2013-05-01-'||REPLACE(CMP.SHIP_CUTOFF_TIME_UTC,':', '.')||'.00' END) AS TIMESTAMP)-5 HOURS) as Vendor_Cut_off
        ,SLR.LEAD_TIME_DAYS AS LEAD_TIME_DAYS
        /*,pp.CONFIRMATION_NOTES*/
        /*,CN.NOTE AS GENERAL_NOTES*/
        /*,LOCALE_TIME_ZONE*/
        ,CONDITION_CODE
        ,PC.PRODUCT_CATEGORY
        ,SLI.PRICE
        ,SLI.QUANTITY * SLI.PRICE AS EXTENDED_PRICE
        ,C.COMPANY_NAME AS SITE_NAME
        ,SLI.COST
  
FROM    PARTS.SLS_LINE_ITEMS as SLI 
        LEFT JOIN parts.sls_orders slo on slo.id_NO= sli.order_id
        LEFT JOIN COMPANIES.COMPANIES_HIERARCHY_V c on c.COMPANY_ID = slo.COMPANY_ID and c.CUSTOMER_IND ='Y'
        LEFT JOIN COMPANIES.COMPANIES_HIERARCHY_V o on o.COMPANY_ID = sli.oem_ID and o.oem_IND ='Y'
		    LEFT JOIN CT.CT_MODALITY_CODES m on m.modality_id = SLI.modality_id 
	      LEFT JOIN PARTS.SLS_LINE_RESEARCHED_VENDORS SLR ON SLI.VENDOR_RESEARCH_ID = SLR.ID_NO
        LEFT JOIN COMPANIES.COMPANIES_HIERARCHY_V v on v.COMPANY_ID = slr.VENDOR_ID and v.Vendor_IND ='Y'
        JOIN COMPANIES.CMP_COMPANIES CMP ON V.COMPANY_ID = CMP.COMPANY_ID
		    LEFT JOIN COMPANIES.CMP_CONTACTS r on r.CONTACT_ID= slo.requestor_id  
        LEFT JOIN (select es.LINE_ITEM_ID, CH.DESCRIPTION , es.ESD, o.USER_NAME
                   from   PARTS.ESTIMATED_SHIP_DATE es 
                          left join CT.ESD_CHANGE_REASONS CH ON CH.REASON_ID = es.REASON_ID 
                          left join CT.PER_PERSONNEL  o on o.ID_NO  = es.CREATED_USER_ID
                   where  ES.ACTIVE ='Y') esd on esd.LINE_ITEM_ID = sli.id_no
        LEFT JOIN ADDRESS_COMBINED ad on ad.LINE_ITEM_ID = sli.id_no
        LEFT JOIN PURCHASE_LINES SPL ON sli.id_no  = SPL.LINE_ITEM_ID
        

       /*left join (select SLICON.LINE_ITEM_ID
                           ,PP.USER_NAME
                           ,slicon.CONFIRMATION_NOTES
                    from   PARTS.SLS_LINE_ITEM_CONFIRMATIONS SLICON
                           left join CT.PER_PERSONNEL PP ON SLICON.CONFIRMED_BY_ID = PP.ID_NO
                           inner join max_time mt on mt.LINE_ITEM_ID = SLICON.LINE_ITEM_ID and mt.TIME_STAMP = SLICON.CREATED_TIMESTAMP) pp on pp.line_item_id = sli.id_no*/
                           
       LEFT JOIN (select SLIN.LINE_ITEM_ID, PP.USER_NAME, SLIN.NOTE
                  from   PARTS.SLS_LINE_ITEM_NOTES SLIN
                         LEFT JOIN CT.PER_PERSONNEL PP ON SLIN.UPDATED_USER_ID = PP.ID_NO
                         inner join max_time_PN mt on mt.LINE_ITEM_ID = SLIN.LINE_ITEM_ID and mt.TIME_STAMP = SLIN.CREATED_TIMESTAMP)CN on CN.line_item_id = sli.id_no
       LEFT JOIN CT.CT_INV_ITEM_CONDITION_CODES COND ON SLR.CONDITION_ID = COND.CONDITION_ID
       LEFT JOIN ct.CT_SLS_STATUS_CODES sc on sc.status_id = sli.status_id 
       LEFT JOIN PARTS.SLS_LINE_ITEM_CONFIRMATIONS vo on vo.line_item_id = sli.id_no
       LEFT JOIN CT.CT_MODALITY_PRODTYPE_RELATIONS MPR on MPR.MODALITY_ID = SLI.MODALITY_ID AND MPR.PRODUCT_TYPE_ID = SLI.CLASS_ID
	   LEFT JOIN ct.CT_PRODUCT_SUB_CATEGORIES p on p.PRODUCT_SUB_CATEGORY_ID = MPR.PRODUCT_SUBCATEGORY_ID
       LEFT JOIN PARTS.SLS_SHIPPING_DOCUMENT_LINES SDL on SDL.LINE_ITEM_ID =  sli.id_no
       LEFT JOIN PARTS.SLS_SHIPPING_DOCUMENTS SSD ON SSD.ID_NO = SDL.SHIPPING_DOCUMENT_ID
       LEFT JOIN COMPANIES.CMP_ADDRESSES cmpa on cmpa.address_id = ssd.SHIP_ADDRESS_ID 
       
       LEFT JOIN (select MPR.PRODUCT_TYPE_ID,
                         MPR.MODALITY_ID,
                         PSC.PRODUCT_SUB_CATEGORY_CODE AS Product_Category
                  from   CT.CT_MODALITY_PRODTYPE_RELATIONS MPR 
                         join CT.CT_PRODUCT_SUB_CATEGORIES PSC ON PSC.PRODUCT_SUB_CATEGORY_ID = MPR.PRODUCT_SUBCATEGORY_ID)PC ON PC.MODALITY_ID = SLI.MODALITY_ID AND PC.PRODUCT_TYPE_ID = SLI.CLASS_ID
       
WHERE  c.lvl1_COMPANY_ID =119 and sli.status_id not in (8,5,13)
>>>>>>> sodexo-open-orders-updates

with ur;
)
;quit;

Proc Print data = WORK.open_orders noobs ;run;