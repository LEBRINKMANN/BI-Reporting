
Select  distinct Lvl1_Company_Id, Lvl1_Company_Name, Shipping_Insurance, 
        sum(tl.TOTAL_REVENUE) as Total_Revenue, year(tl.TRANSACTION_DATE) as Transaction_Year
From    DW.CUSTOMERS c
        INNER JOIN DW.F_AR_TRANSACTION_LINES tl on tl.CUSTOMER_ID = c.COMPANY_ID
where   c.SHIPPING_INSURANCE = 'N' and year(tl.transaction_date) = 2021 and tl.ORDERS_IND = 1
Group By Lvl1_Company_Id, Lvl1_Company_Name, Shipping_Insurance, year(tl.TRANSACTION_DATE)