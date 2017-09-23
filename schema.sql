-- loaded
CREATE TABLE activity_type (
  activitytypeid integer,
  name varchar(100),
  description varchar(100),
  primaryactivitytypeattributename varchar(100),
  primaryactivitytypeattributedatatype varchar(100),
  processed_date timestamp
);

CREATE INDEX at_activitytypeid ON activity_type (activitytypeid);
ANALYZE activity_type (activitytypeid);

drop table accounts;
create table accounts (
    accountsid varchar(100),
    leadid integer,
    emailaddress varchar(100),
    account_type varchar(100),
    cust_class varchar(100),
    account_categorysid int,
    gender varchar(100),
    marital_status varchar(100),
    occupation text,
    companysid text,
    industrysid  varchar(100),
    managersid  varchar(100),
    annual_income  varchar(100),
    eduinfo  varchar(100),
    agerange  varchar(100),
    kore_primaryacctnbr  varchar(100),
    accountflag  varchar(100),
    appusersid  varchar(100),
    createdate timestamp,
    updatedate timestamp,
    dwainsertdate timestamp,
    dwaupdatedate timestamp,
    dwaprocessid numeric
);

CREATE INDEX accounts_accountsid ON accounts (accountsid);
CREATE INDEX accounts_leadid ON accounts (leadid);
ANALYZE accounts (accountsid, leadid);


-- loaded
CREATE TABLE contact (
  contactid varchar(100),
  accountnumber integer,
  buyertype varchar(50),
  nbafico_score integer,
  broker_flag integer,
  is_seasonticketholder_flag integer,
  seasonticketholdersince_date timestamp,
  personicx_cluster varchar(50),
  miles_from_facility float,
  age varchar(50),
  education varchar(50),
  home_market_value varchar(50),
  home_owner_renter varchar(50),
  income varchar(50),
  marital_status varchar(50),
  discretionary_income_index integer,
  dwelling_type varchar(50),
  home_property_type varchar(50),
  number_of_adults varchar(50),
  occupation varchar(50),
  retail_frequent_category varchar(100),
  primary_vehicle varchar(50),
  is_spectator_sports__basketball varchar(50)
);

CREATE INDEX contact_contactid ON contact (contactid);
CREATE INDEX contact_accountnumber ON contact (accountnumber);
ANALYZE contact (contactid, accountnumber);

-- loaded
create table activity (
    activityid int,
    leadid int,
    activitydate timestamp,
    activitytypeid int,
    primaryactivityattributeid int,
    processed_date timestamp
)

CREATE INDEX activity_activityid ON activity (activityid);
CREATE INDEX activity_activitytypeid ON activity (activitytypeid);
CREATE INDEX activity_leadid ON activity (leadid);
ANALYZE activity (activityid, leadid, activitytypeid);

create table activity_details AS (
  select a.*,b.name, b.description
  from activity as a
  join activity_type as b
  on a.activitytypeid=b.activitytypeid
)

CREATE INDEX activity_details_activityid ON activity_details (activityid);
CREATE INDEX activity_details_activitytypeid ON activity_details (activitytypeid);
CREATE INDEX activity_details_leadid ON activity_details (leadid);
ANALYZE activity_details (activityid, leadid, activitytypeid);

drop table ticket_transaction;

CREATE TABLE ticket_transaction (
  tickettransactionsid varchar(100),
  accountsid varchar(100),
  contactid bigint,
  productsid bigint,
  ordernbr integer,
  transactiondate timestamp,
  seatsid varchar(50),
  ticketqty integer,
  dealedqty integer,
  minsplit int,
  pricesid varchar(50),
  offersid int,
  purchase_price numeric,
  tickettypesid varchar(50),
  ticket_status varchar(50),
  transactiontypesid varchar(50),
  pricelevelsid varchar(50),
  zonesid integer,
  previousaccountsid varchar(50),
  previouscontact_id bigint,
  originalaccountsid varchar(50),
  originalcontact_id bigint,
  originalproductid bigint,
  originalticketid bigint,
  transactiondatesid timestamp,
  add_usersid integer,
  appsystemsid integer,
  companysid integer,
  dwainsertdate timestamp,
  dwaupdatedate timestamp
);

CREATE TABLE ticket_transaction (
  accountsid varchar(100),
  contact_id bigint,
  productsid bigint,
  transactiondate timestamp,
  seatsid varchar(50),
  ticketqty integer,
  offersid integer,
  zonesid integer
)
;


CREATE INDEX ticket_transaction_accountsid ON ticket_transaction (accountsid);
CREATE INDEX ticket_transaction_contact_id ON ticket_transaction (contact_id);
CREATE INDEX ticket_transaction_productsid ON ticket_transaction (productsid);
ANALYZE ticket_transaction (accountsid, productsid, contact_id);


-- loaded
create table product (
    productsid int,
    eventsid int,
    eventcode varchar(10),
    event_status int,
    eventtypecode varchar(10),
    eventtype_desc varchar(20),
    eventdatetime timestamp,
    onsaledatetime timestamp,
    offsaledatetime timestamp,
    seasonsid int,
    season_year int,
    plan_flag int,
    totalevents int,
    fse decimal,
    gamenbr int,
    team2 varchar(20),
    producttier varchar(20),
    createdate timestamp,
    updatedate timestamp,
    dwainsertdate timestamp,
    dwaupdatedate timestamp
);


CREATE INDEX product_accountsid ON product (productsid);
ANALYZE product (productsid);
