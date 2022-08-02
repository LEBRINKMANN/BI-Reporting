select distinct  cont.CONTACT_ID as ID
  , cont.LOGIN_USER_ID
  , COALESCE(cont.LOGIN_USER_ID, CAST(cont.CONTACT_ID as varchar(25))) as Login
  , cont.FIRST_NAME as FirstName
  , cont.LAST_NAME as LastName
  , (select e.EMAIL from COMPANIES.CMP_CONTACT_EMAILS e where e.ACTIVE = 'Y' and e.CONTACT_ID = cont.CONTACT_ID and e.DEFAULT_EMAIL = 'Y' order by e.UPDATED_TIMESTAMP desc fetch first 1 rows only) as EmailAddress
  , (select m.MOBILE_NUMBER from COMPANIES.CMP_CONTACT_MOBILE m where m.CONTACT_ID = cont.CONTACT_ID order by m.UPDATED_TIMESTAMP desc fetch first 1 rows only) as MobilePhoneNumber
  , COALESCE(cont.PASSWORD, x'000D10257F022D98C4E11214F4AF97798BD84473') as HashedPassword
  , cont.LAST_LOGIN_DATE as LastLogin
  , cont.EPARTSFINDER_MEMBER as ApolloMember
  , CASE WHEN vcont.CONTACT_ID IS NOT NULL    THEN 'Y'    ELSE 'N'  END as SupplierMember
from COMPANIES.CMP_CONTACTS cont
inner join COMPANIES.CMP_COMPANY_CONTACTS cc on cc.CONTACT_ID = cont.CONTACT_ID
inner join COMPANIES.CMP_COMPANIES c on c.COMPANY_ID = cc.COMPANY_ID
left join (select distinct vc.CONTACT_ID
           from COMPANIES.VND_VENDORS_CONTACTS vc 
                inner join COMPANIES.CMP_COMPANIES c on c.COMPANY_ID = vc.VENDOR_ID
                inner join companies.CMP_COMPANY_TYPES ctype on ctype.COMPANY_ID = c.COMPANY_ID
                inner join ct.CT_CMP_COMPANY_TYPES  type on type.company_type_id = ctype.COMPANY_TYPE_ID
           where vc.ACTIVE = 'Y'and vc.SUPPLIER_WEB_ACCESS = 'Y'and type.TYPE_GROUP = 'V'and vc.SUPPLIER_WEB_ACCESS = 'Y') as vcont on vcont.CONTACT_ID = cont.CONTACT_ID

where cont.ACTIVE = 'Y'
and cc.ACTIVE = 'Y'
and c.ACTIVE = 'Y'
and (cont.EPARTSFINDER_MEMBER = 'Y' or vcont.CONTACT_ID is not null)

--and cont.PASSWORD is not nulland (select e.EMAIL from COMPANIES.CMP_CONTACT_EMAILS e where e.ACTIVE = 'Y' and e.CONTACT_ID = cont.CONTACT_ID and e.DEFAULT_EMAIL = 'Y' order by e.UPDATED_TIMESTAMP desc fetch first 1 rows only) is not nullorder by cont.LAST_LOGIN_DATE desc;
with ur;