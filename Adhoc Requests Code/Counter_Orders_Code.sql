/*Request from Kelly Trefny on 2/23/2022
provide me with a list of orders for the last 6 month to current that were listed as COUNTER TO COUNTER
I need:
REF#
PS PO#
SHP FREIGHT (amount)
*/

Select  LID.Line_Item_Id AS Reference_Number
        ,LID.Gp_Po_Number AS PS_PO_Number
        ,SI.Ship_Freight 
        ,LID.PO_DATE AS Order_Date
From    DW.LINE_ITEM_DETAILS LID
        JOIN DW.SHIPPING_INFO SI ON SI.LINE_ITEM_ID = LID.LINE_ITEM_ID AND SI.SHIPPING_METHOD = 'COUNTER'
Where   LID.PO_Date Between '8/1/2021' and CURRENT_TIMESTAMP         
        