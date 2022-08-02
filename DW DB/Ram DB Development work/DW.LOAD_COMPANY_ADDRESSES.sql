CREATE PROCEDURE DW.LOAD_COMPANY_ADDRESSES ( )
	LANGUAGE SQL
	NOT DETERMINISTIC
	NO EXTERNAL ACTION
	MODIFIES SQL DATA
	CALLED ON
	NULL INPUT
	INHERIT SPECIAL REGISTERS
	OLD SAVEPOINT LEVEL
	
BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE DW.COMPANY_ADDRESSES IMMEDIATE REUSE STORAGE';

    CALL SYSPROC.ADMIN_CMD ('LOAD FROM (
                                SELECT
                                       c.COMPANY_ID
                                      ,c.ROOT_COMPANY_ID 
                                      ,a.RESPONSIBLE_COMPANY_ID
                                      ,t.ADDRESS_TYPE_CODE
                                      ,rc.COMPANY_NAME AS RESPONSIBLE_COMPANY_NAME
                                      ,a.ADDRESS_DESCRIPTION
                                      ,a.ADDRESS1
                                      ,a.ADDRESS2
                                      ,a.ADDRESS3
                                      ,a.ZIP
                                      ,a.CITY
                                      ,a.STATE
                                      ,a.COUNTRY
      								                ,a.EDI_SENDER_CODE
                                FROM
                                      REMOTE_DB2P.companies.CMP_ADDRESSES a
                                      JOIN REMOTE_DB2P.companies.CMP_COMPANY_ADDRESSES ca ON a.ADDRESS_ID = ca.ADDRESS_ID
                                      JOIN REMOTE_DB2P.companies.CMP_COMPANIES c ON c.COMPANY_ID = ca.COMPANY_ID
                                      LEFT JOIN REMOTE_DB2P.companies.CMP_COMPANIES rc ON rc.COMPANY_ID = a.RESPONSIBLE_COMPANY_ID
                                      JOIN REMOTE_DB2P.CT.CT_ADDRESS_TYPES t ON a.ADDRESS_TYPE_ID = t.ADDRESS_TYPE_ID
                                WHERE
                                      a.ACTIVE = ''Y'' AND
                                      ca.ACTIVE = ''Y''
                                ORDER BY 
                                        c.COMPANY_ID
                                with ur
                                ) OF CURSOR INSERT INTO DW.COMPANY_ADDRESSES NONRECOVERABLE');


	COMMIT;
	
END