#accounts_scrubbed.csv
drop = c("accountsid", 
         "leadid", 
         "emailaddress", 
         "companysid", 
         "industrysid",
         "managersid",
         "kore_primaryacctnbr",
         "appusersid")

#tickettransaction.csv
drop = c("tickettransactionsid",
         "accountsid", 
         "contact_id",
         "previousaccountsid",
         "previouscontact_id",
         "originalaccountsid",
         "originalcontact_id",
         "originalproductid",
         "originalticketid", 
         "transactiondatesid")

#sqlcontact.csv
drop = c("contactid",
         "accountnumber")

#activityattribute.txt
drop = c("activitytypeid", 
         "primaryactivityattributeid")

#activitytype_000.txt
drop = c("name", 
         "description", 
         "primaryactivitytypeattributedatatype")

#activitytypeattributes_000.txt
drop = c ("datatype")
