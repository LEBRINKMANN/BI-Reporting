with procustomers as (
select coalesce(pro.SITE_ID, pro.PARENT_ID) as Company_Id,
       pro.PROGRAM_NAME
from  DW.ENTERPRISE_DETAILS_SITES pro
where pro.END_DATE is null or pro.END_DATE > current_timestamp
      and pro.PROGRAM_Type = 'Subscription'
)

-- that id could be joined to a parent Id