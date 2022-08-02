CREATE OR REPLACE PROCEDURE DW.LOAD_CUSTOMERS ( )
	SPECIFIC SQL160916160852932
	LANGUAGE SQL
	NOT DETERMINISTIC
	NO EXTERNAL ACTION
	MODIFIES SQL DATA
	CALLED ON
	NULL INPUT
	INHERIT SPECIAL REGISTERS
	OLD SAVEPOINT LEVEL
BEGIN
   

	EXECUTE IMMEDIATE 'TRUNCATE TABLE DW.CUSTOMERS IMMEDIATE REUSE STORAGE';


    CALL SYSPROC.ADMIN_CMD ('LOAD FROM (
                            SELECT c.COMPANY_ID
                                  , c."LEVEL"
                                  , c.COMPANY_NAME
                                  , c.COMPANY_TYPE_ID
                                  , c.COMPANY_TYPE_CODE
                                  , c.COMPANY_TYPE_DESCRIPTION
                                  , c.TYPE_GROUP
                                  , c.ACTIVE
                                  , c.EPARTSFINDER_IND
                                  , c.LVL1_COMPANY_ID
                                  , c.LVL2_COMPANY_ID
                                  , c.LVL3_COMPANY_ID
                                  , c.LVL4_COMPANY_ID
                                  , c.LVL5_COMPANY_ID
                                  , c.LVL6_COMPANY_ID
                                  , c.LVL7_COMPANY_ID
                                  , c.LVL1_COMPANY_NAME
                                  , c.LVL2_COMPANY_NAME
                                  , c.LVL3_COMPANY_NAME
                                  , c.LVL4_COMPANY_NAME
                                  , c.LVL5_COMPANY_NAME
                                  , c.LVL6_COMPANY_NAME
                                  , c.LVL7_COMPANY_NAME
                                  , c.CUSTOMER_SEGMENT
                                  , c.SALESREP_ID
                                  , c.OUTSIDE_SALESREP_ID
                                  , c.BED_SIZE
                                  , c.ADDRESS1
                                  , c.ADDRESS2
                                  , c.ADDRESS3
                                  , c.CITY
                                  , c.STATE
                                  , c.ZIP
                                  , c.COUNTRY
                                  , c.REGION
                                  , c.SITE_ZONE
                                  , c.TIER_CODE
                                  , c.BIOMED_AM
                                  , c.IMAGING_AM
                                  , c.QUALITATIVE_SCORE
                                  , c.PAYMENT_TERM_CODE
                                  , c.SMART_ORDER_ENABLED
                                  , c.SMART_LABEL_ENABLED
                                  , c.EPV_MEMBER
                                  , c.Customer_Care_AM
                                  , GP.CUSTOMER_ID_GP
                                  , c.HEALTH_SYSTEM_ID
                                  , c.CREDIT_HOLD
                                  , c.UPS_ACCOUNT_NUMBER
                                  , c.FEDEX_ACCOUNT_NUMBER
                                  , (SELECT UPPER(GI.DESCRIPTION) AS REPORTING_REGION
        										         FROM    REMOTE_DB2P.COMPANIES.CMP_COMPANY_GROUP_MEMBERSHIP GM
        											              JOIN REMOTE_DB2P.CT.CT_SYS_GROUP_ITEMS GI ON GI.GROUP_ITEM_ID = GM.GROUP_ITEM_ID
        											       WHERE GM.GROUP_ID = 17 AND GM.COMPANY_ID = C.COMPANY_ID) AS REPORTING_REGION
								                  , (SELECT UPPER(GI.DESCRIPTION) AS PROGRAM_TYPE
                										 FROM REMOTE_DB2P.COMPANIES.CMP_COMPANY_GROUP_MEMBERSHIP GM
                											      JOIN REMOTE_DB2P.CT.CT_SYS_GROUP_ITEMS GI ON GI.GROUP_ITEM_ID = GM.GROUP_ITEM_ID
                										WHERE GM.GROUP_ID = 16 AND GM.COMPANY_ID = C.COMPANY_ID) AS PROGRAM_TYPE
                                  ,COALESCE(CS.SETTING_VALUE, ''3'')  AS CUSTOMER_TIER
                                  ,case when CS1.SETTING_VALUE = 1 then ''Manual'' else ''Auto'' end AS Auto_Manual_Quote
                                  ,CS2.SETTING_VALUE AS Quote_Limit
                                  ,CS3.SETTING_VALUE AS OEM_List_outright_price
                                  ,CS4.SETTING_VALUE AS OEM_List_exchange_price
                                  ,case when CS5.SETTING_VALUE = 0 then ''NoRFQ''
										                    when CS5.SETTING_VALUE = 1 then ''AllowAll''
										                    when CS5.SETTING_VALUE = 2 then ''AllowPFOnly''
                                        when CS5.SETTING_VALUE = 3 then ''AllowApolloOnly''
                                        when CS5.SETTING_VALUE = 4 then ''Limited''
                                        when CS5.SETTING_VALUE = 5 then ''SeeParent''
                                        else ''SeeParent'' end AS RFQ_management
                                  ,COALESCE(CS6.SETTING_VALUE,''N'') AS Shipping_insurance
                                  ,case when INV_BATCH_TYPE = 0 then ''Other''
                                          when INV_BATCH_TYPE = 1 then ''Mail''
                                          when INV_BATCH_TYPE = 2 then ''Email''
                                          when INV_BATCH_TYPE = 3 then ''EDI''
                                          when INV_BATCH_TYPE = 4 then ''No Mail''
                                          when INV_BATCH_TYPE = 5 then ''CC Batch''
                                          when INV_BATCH_TYPE = 6 then ''Warrenty Items''
                                          when INV_BATCH_TYPE = 7 then ''Warrenty CC Items''
                                          else '''' end as Batch_Invoice
                                  ,IS_USE_ALT_PO_NUMBER
                                  ,COALESCE(Tax.IS_TAX_EXEMPT, ''N'') as IS_TAX_EXEMPT -- Tax Exempt
                                  ,cmp.CREATED_TIMESTAMP
								                  ,cmp.SALESREP_ID
                                  ,ProInd.Description as Reporting_Pro_Ind
                                  ,SalesRegion.Description as Reporting_Sales_Region

                            FROM  DW.COMPANIES c
                                  LEFT JOIN REMOTE_DB2P.COMPANIES.XLT_CUSTOMER_GP GP ON GP.CUSTOMER_ID = c.COMPANY_ID
                                  LEFT JOIN DW.CUSTOMER_SETTINGS CS ON CS.COMPANY_ID = C.COMPANY_ID AND CS.SETTING_ID =91 --Customer Tier
                                  LEFT JOIN DW.CUSTOMER_SETTINGS CS1 ON CS1.COMPANY_ID = C.COMPANY_ID AND CS1.SETTING_ID =92 --Auto Manual Quote
                                  LEFT JOIN DW.CUSTOMER_SETTINGS CS2 ON CS2.COMPANY_ID = C.COMPANY_ID AND CS2.SETTING_ID =93 --Quote Limit
                                  LEFT JOIN DW.CUSTOMER_SETTINGS CS3 ON CS3.COMPANY_ID = C.COMPANY_ID AND CS3.SETTING_ID =94 --OEM List outright price
                                  LEFT JOIN DW.CUSTOMER_SETTINGS CS4 ON CS4.COMPANY_ID = C.COMPANY_ID AND CS4.SETTING_ID =95 --OEM List exchange price
                                  LEFT JOIN DW.CUSTOMER_SETTINGS CS5 ON CS5.COMPANY_ID = C.COMPANY_ID AND CS5.SETTING_ID =87 --RFQ management
                                  LEFT JOIN DW.CUSTOMER_SETTINGS CS6 ON CS6.COMPANY_ID = C.COMPANY_ID AND CS6.SETTING_ID =66 --Shipping Insurance
                                  LEFT JOIN REMOTE_DB2P.COMPANIES.CMP_COMPANY_BILLING_INFO CBI ON CBI.COMPANY_ID = C.COMPANY_ID
                                  LEFT JOIN REMOTE_DB2P.Companies.CMP_COMPANY_TAX_EXEMPT_STATUS TAX ON TaX.GP_COMPANY_ID =CUSTOMER_ID_GP
      							              LEFT JOIN (Select ProInd.Group_Id,
      											                        ProIndValue.Description,
      											                        ccgm.Company_Id
                        										 FROM   REMOTE_DB2P.companies.cmp_company_group_membership ccgm
                        										        LEFT JOIN REMOTE_DB2P.CT.CT_SYS_GROUPS ProInd ON ccgm.GROUP_ID = ProInd.GROUP_ID 
                        										        LEFT JOIN REMOTE_DB2P.CT.CT_SYS_GROUP_ITEMS ProIndValue ON ccgm.GROUP_ITEM_ID = ProIndValue.GROUP_ITEM_ID
                        										 Where  ProInd.group_id =16) ProInd on ProInd.Company_Id = c.COMPANY_ID
                                  LEFT JOIN (Select ProInd.Group_Id,
                                                    ProIndValue.Description,
                                                    ccgm.Company_Id
                                      			 FROM   REMOTE_DB2P.companies.cmp_company_group_membership ccgm
                                                    LEFT JOIN REMOTE_DB2P.CT.CT_SYS_GROUPS ProInd ON ccgm.GROUP_ID = ProInd.GROUP_ID 
                                                    LEFT JOIN REMOTE_DB2P.CT.CT_SYS_GROUP_ITEMS ProIndValue ON ccgm.GROUP_ITEM_ID = ProIndValue.GROUP_ITEM_ID
                                      			 Where  ProInd.group_id =17) SalesRegion on SalesRegion.Company_Id = c.COMPANY_ID
                                  JOIN COMPANIES.CMP_COMPANIES CMP ON C.COMPANY_ID = CMP.COMPANY_ID
                          WHERE CUSTOMER_IND = ''Y''
                          with ur
                          ) OF CURSOR INSERT INTO DW.CUSTOMERS NONRECOVERABLE');
                            

							
	COMMIT;
    
END