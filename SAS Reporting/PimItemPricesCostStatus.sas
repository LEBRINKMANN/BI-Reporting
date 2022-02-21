proc  sql;

create table warehouse as 
select 
pp.*
,max(datepart(l.po_date)) as LAst_Po_date format = mmddyy10.
,max(q.price) as Max_Price
,max(ip.outright_cost) as Max_Outright_Cost
,max(h.status_id) as Status_Id

from WORK.'Photo buy'n as pp
left join d_dw.line_item_details l on l.pim_item_number = pp.PS_AUR_Vstring and l.vendor_id in(24933)
left join d_dw.pim_item_prices ip on ip.search_item_number = pp.PS_AUR_Vstring
left join d_dw.pim_historical_items h on h.item_number = pp.PS_AUR_Vstring
left join d_dw.rorm_all q on q.line_item_id = l.line_item_id 
	and orders = 1 and Q.TRANSACTION_DATE BETWEEN "01nov2020"d and "28jan2022"d
  
group by 1,2,3,4,5,6,7,8,9
;quit;

proc export data=work.warehouse
    outfile="C:\Users\sdakdouk\OneDrive - PartsSource\Desktop\SASExports\photobuy1.xlsx"
    dbms=xlsx
	replace;
	sheet='Results';
run;