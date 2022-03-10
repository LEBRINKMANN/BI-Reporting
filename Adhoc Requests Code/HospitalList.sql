      
SELECT  C.COMPANY_NAME AS Customer,
        C.ADDRESS1 AS Address,
        C.Zip,
        c.COMPANY_TYPE_CODE,
        sum (r.REVENUE) AS Revenue,
        sum (orders) AS Orders
FROM    DW.RORM_ALL r
        LEFT JOIN DW.CUSTOMERs c ON c.COMPANY_ID = r.customer_id
        LEFT JOIN (SELECT DISTINCT e.parent_id
                  FROM DW.Enterprise_Details_Sites E
                  WHERE E.Program_Type = 'Subscription'
                  AND (E.End_Date IS NULL OR E.End_Date > CURRENT_TIMESTAMP)) e ON e.parent_id = c.lvl1_company_id
WHERE   r.TRANSACTION_TIMESTAMP BETWEEN first_DAY (CURRENT DATE - 12 MONTHS) AND last_DAY (CURRENT DATE - 1 MONTHS)
        AND e.parent_id IS NULL
GROUP BY  C.COMPANY_NAME,
          C.ADDRESS1,
          C.Zip,
          c.COMPANY_TYPE_CODE
          
          
          