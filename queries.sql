
-- half the accounts are missing a lead id
select sum(case when leadid is null then 1 else 0 end)::float/count(*)::float as lead_null_cnt
from accounts
;


select count(*) as dupe_cnt, sum(cnt) as total_cnt
from (
select accountsid, count(*) as cnt
from accounts
group by 1
) as a
where cnt>1
;


-- ticket transactions in 2015-2016 season
CREATE TEMPORARY TABLE past_transactions AS (
  SELECT
    trxn.accountsid,
    trxn.productsid, --
    trxn.offersid, --
    trxn.seatsid,
    trxn.zonesid,
    MIN(trxn.transactiondate) AS transaction_date,
    MIN(COALESCE(prod.producttier,'Other')) AS producttier
  FROM
    ticket_transaction AS trxn
  JOIN
    product AS prod
  ON
    trxn.productsid=prod.productsid
  WHERE
    offersid IS NOT NULL -- filter out test accounts
    AND transactiondate::date <= '2016-04-14'
    AND transactiondate::date >= '2015-07-01'
  GROUP BY 1,2,3,4,5
)
;


CREATE TEMPORARY TABLE future_transactions AS (
  SELECT
    accountsid,
    count(distinct seatsid || cast(productsid as varchar)) tickets_purchased
  FROM
    ticket_transaction
  WHERE
    transactiondate::date > '2016-05-01'
  GROUP BY 1
)
;


create table past_trxn_trending as
select accountsid
    ,sum(case when producttier = 'Select' then 1 else 0 end) select_tickets
    ,sum(case when producttier = 'Value' then 1 else 0 end) value_tickets
    ,sum(case when producttier = 'Marquee' then 1 else 0 end) marquee_tickets
    ,sum(case when producttier = 'SuperSaver' then 1 else 0 end) supersaver_tickets
    ,sum(case when producttier = 'Preseason' then 1 else 0 end) preseason_tickets
    ,sum(case when producttier = 'Premier' then 1 else 0 end) premier_tickets
    ,sum(case when producttier = 'Elite' then 1 else 0 end) elite_tickets
    ,sum(case when producttier = 'Other' then 1 else 0 end) other_tickets
    ,sum(case when producttier = 'Select' and transaction_date::date > '2016-01-14' then 1 else 0 end) select_tickets_90d
    ,sum(case when producttier = 'Value' and transaction_date::date > '2016-01-14' then 1 else 0 end) value_tickets_90d
    ,sum(case when producttier = 'Marquee' and transaction_date::date > '2016-01-14' then 1 else 0 end) marquee_tickets_90d
    ,sum(case when producttier = 'SuperSaver' and transaction_date::date > '2016-01-14' then 1 else 0 end) supersaver_tickets_90d
    ,sum(case when producttier = 'Preseason' and transaction_date::date > '2016-01-14' then 1 else 0 end) preseason_tickets_90d
    ,sum(case when producttier = 'Premier' and transaction_date::date > '2016-01-14' then 1 else 0 end) premier_tickets_90d
    ,sum(case when producttier = 'Elite' and transaction_date::date > '2016-01-14' then 1 else 0 end) elite_tickets_90d
    ,sum(case when producttier = 'Other' and transaction_date::date > '2016-01-14' then 1 else 0 end) other_tickets_90d
    ,sum(case when producttier = 'Select' and transaction_date::date > '2016-03-14' then 1 else 0 end) select_tickets_30d
    ,sum(case when producttier = 'Value' and transaction_date::date > '2016-03-14' then 1 else 0 end) value_tickets_30d
    ,sum(case when producttier = 'Marquee' and transaction_date::date > '2016-03-14' then 1 else 0 end) marquee_tickets_30d
    ,sum(case when producttier = 'SuperSaver' and transaction_date::date > '2016-03-14' then 1 else 0 end) supersaver_tickets_30d
    ,sum(case when producttier = 'Preseason' and transaction_date::date > '2016-03-14' then 1 else 0 end) preseason_tickets_30d
    ,sum(case when producttier = 'Premier' and transaction_date::date > '2016-03-14' then 1 else 0 end) premier_tickets_30d
    ,sum(case when producttier = 'Elite' and transaction_date::date > '2016-03-14' then 1 else 0 end) elite_tickets_30d
    ,sum(case when producttier = 'Other' and transaction_date::date > '2016-03-14' then 1 else 0 end) other_tickets_30d
from past_transactions
group by 1
;


CREATE TABLE ninetyd_activity AS (
  SELECT
    b.accountsid,
    SUM(CASE WHEN activitytypeid = 1 THEN 1 ELSE 0 END) AS ninetyd_activity_1,
    SUM(CASE WHEN activitytypeid = 10 THEN 1 ELSE 0 END) AS ninetyd_activity_10,
    SUM(CASE WHEN activitytypeid = 100 THEN 1 ELSE 0 END) AS ninetyd_activity_100,
    SUM(CASE WHEN activitytypeid = 1002 THEN 1 ELSE 0 END) AS ninetyd_activity_1002,
    SUM(CASE WHEN activitytypeid = 1005 THEN 1 ELSE 0 END) AS ninetyd_activity_1005,
    SUM(CASE WHEN activitytypeid = 101 THEN 1 ELSE 0 END) AS ninetyd_activity_101,
    SUM(CASE WHEN activitytypeid = 104 THEN 1 ELSE 0 END) AS ninetyd_activity_104,
    SUM(CASE WHEN activitytypeid = 106 THEN 1 ELSE 0 END) AS ninetyd_activity_106,
    SUM(CASE WHEN activitytypeid = 108 THEN 1 ELSE 0 END) AS ninetyd_activity_108,
    SUM(CASE WHEN activitytypeid = 11 THEN 1 ELSE 0 END) AS ninetyd_activity_11,
    SUM(CASE WHEN activitytypeid = 110 THEN 1 ELSE 0 END) AS ninetyd_activity_110,
    SUM(CASE WHEN activitytypeid = 111 THEN 1 ELSE 0 END) AS ninetyd_activity_111,
    SUM(CASE WHEN activitytypeid = 112 THEN 1 ELSE 0 END) AS ninetyd_activity_112,
    SUM(CASE WHEN activitytypeid = 113 THEN 1 ELSE 0 END) AS ninetyd_activity_113,
    SUM(CASE WHEN activitytypeid = 114 THEN 1 ELSE 0 END) AS ninetyd_activity_114,
    SUM(CASE WHEN activitytypeid = 115 THEN 1 ELSE 0 END) AS ninetyd_activity_115,
    SUM(CASE WHEN activitytypeid = 12 THEN 1 ELSE 0 END) AS ninetyd_activity_12,
    SUM(CASE WHEN activitytypeid = 13 THEN 1 ELSE 0 END) AS ninetyd_activity_13,
    SUM(CASE WHEN activitytypeid = 145 THEN 1 ELSE 0 END) AS ninetyd_activity_145,
    SUM(CASE WHEN activitytypeid = 2 THEN 1 ELSE 0 END) AS ninetyd_activity_2,
    SUM(CASE WHEN activitytypeid = 22 THEN 1 ELSE 0 END) AS ninetyd_activity_22,
    SUM(CASE WHEN activitytypeid = 24 THEN 1 ELSE 0 END) AS ninetyd_activity_24,
    SUM(CASE WHEN activitytypeid = 25 THEN 1 ELSE 0 END) AS ninetyd_activity_25,
    SUM(CASE WHEN activitytypeid = 27 THEN 1 ELSE 0 END) AS ninetyd_activity_27,
    SUM(CASE WHEN activitytypeid = 3 THEN 1 ELSE 0 END) AS ninetyd_activity_3,
    SUM(CASE WHEN activitytypeid = 300 THEN 1 ELSE 0 END) AS ninetyd_activity_300,
    SUM(CASE WHEN activitytypeid = 32 THEN 1 ELSE 0 END) AS ninetyd_activity_32,
    SUM(CASE WHEN activitytypeid = 37 THEN 1 ELSE 0 END) AS ninetyd_activity_37,
    SUM(CASE WHEN activitytypeid = 38 THEN 1 ELSE 0 END) AS ninetyd_activity_38,
    SUM(CASE WHEN activitytypeid = 39 THEN 1 ELSE 0 END) AS ninetyd_activity_39,
    SUM(CASE WHEN activitytypeid = 40 THEN 1 ELSE 0 END) AS ninetyd_activity_40,
    SUM(CASE WHEN activitytypeid = 400 THEN 1 ELSE 0 END) AS ninetyd_activity_400,
    SUM(CASE WHEN activitytypeid = 401 THEN 1 ELSE 0 END) AS ninetyd_activity_401,
    SUM(CASE WHEN activitytypeid = 402 THEN 1 ELSE 0 END) AS ninetyd_activity_402,
    SUM(CASE WHEN activitytypeid = 403 THEN 1 ELSE 0 END) AS ninetyd_activity_403,
    SUM(CASE WHEN activitytypeid = 405 THEN 1 ELSE 0 END) AS ninetyd_activity_405,
    SUM(CASE WHEN activitytypeid = 406 THEN 1 ELSE 0 END) AS ninetyd_activity_406,
    SUM(CASE WHEN activitytypeid = 407 THEN 1 ELSE 0 END) AS ninetyd_activity_407,
    SUM(CASE WHEN activitytypeid = 408 THEN 1 ELSE 0 END) AS ninetyd_activity_408,
    SUM(CASE WHEN activitytypeid = 409 THEN 1 ELSE 0 END) AS ninetyd_activity_409,
    SUM(CASE WHEN activitytypeid = 41 THEN 1 ELSE 0 END) AS ninetyd_activity_41,
    SUM(CASE WHEN activitytypeid = 410 THEN 1 ELSE 0 END) AS ninetyd_activity_410,
    SUM(CASE WHEN activitytypeid = 45 THEN 1 ELSE 0 END) AS ninetyd_activity_45,
    SUM(CASE WHEN activitytypeid = 46 THEN 1 ELSE 0 END) AS ninetyd_activity_46,
    SUM(CASE WHEN activitytypeid = 47 THEN 1 ELSE 0 END) AS ninetyd_activity_47,
    SUM(CASE WHEN activitytypeid = 48 THEN 1 ELSE 0 END) AS ninetyd_activity_48,
    SUM(CASE WHEN activitytypeid = 6 THEN 1 ELSE 0 END) AS ninetyd_activity_6,
    SUM(CASE WHEN activitytypeid = 7 THEN 1 ELSE 0 END) AS ninetyd_activity_7,
    SUM(CASE WHEN activitytypeid = 8 THEN 1 ELSE 0 END) AS ninetyd_activity_8,
    SUM(CASE WHEN activitytypeid = 9 THEN 1 ELSE 0 END) AS ninetyd_activity_9
  FROM activity a
  JOIN accounts b
  ON a.leadid = b.leadid
  WHERE a.activitydate::date BETWEEN '2016-01-14' and '2016-04-14'
  GROUP BY 1
)
;



create table thirtyd_activity as
select
    b.accountsid
    ,sum(case when activitytypeid = 1 then 1 else 0 end) as thirtyd_activity_1
    ,sum(case when activitytypeid = 10 then 1 else 0 end) as thirtyd_activity_10
    ,sum(case when activitytypeid = 100 then 1 else 0 end) as thirtyd_activity_100
    ,sum(case when activitytypeid = 1002 then 1 else 0 end) as thirtyd_activity_1002
    ,sum(case when activitytypeid = 1005 then 1 else 0 end) as thirtyd_activity_1005
    ,sum(case when activitytypeid = 101 then 1 else 0 end) as thirtyd_activity_101
    ,sum(case when activitytypeid = 104 then 1 else 0 end) as thirtyd_activity_104
    ,sum(case when activitytypeid = 106 then 1 else 0 end) as thirtyd_activity_106
    ,sum(case when activitytypeid = 108 then 1 else 0 end) as thirtyd_activity_108
    ,sum(case when activitytypeid = 11 then 1 else 0 end) as thirtyd_activity_11
    ,sum(case when activitytypeid = 110 then 1 else 0 end) as thirtyd_activity_110
    ,sum(case when activitytypeid = 111 then 1 else 0 end) as thirtyd_activity_111
    ,sum(case when activitytypeid = 112 then 1 else 0 end) as thirtyd_activity_112
    ,sum(case when activitytypeid = 113 then 1 else 0 end) as thirtyd_activity_113
    ,sum(case when activitytypeid = 114 then 1 else 0 end) as thirtyd_activity_114
    ,sum(case when activitytypeid = 115 then 1 else 0 end) as thirtyd_activity_115
    ,sum(case when activitytypeid = 12 then 1 else 0 end) as thirtyd_activity_12
    ,sum(case when activitytypeid = 13 then 1 else 0 end) as thirtyd_activity_13
    ,sum(case when activitytypeid = 145 then 1 else 0 end) as thirtyd_activity_145
    ,sum(case when activitytypeid = 2 then 1 else 0 end) as thirtyd_activity_2
    ,sum(case when activitytypeid = 22 then 1 else 0 end) as thirtyd_activity_22
    ,sum(case when activitytypeid = 24 then 1 else 0 end) as thirtyd_activity_24
    ,sum(case when activitytypeid = 25 then 1 else 0 end) as thirtyd_activity_25
    ,sum(case when activitytypeid = 27 then 1 else 0 end) as thirtyd_activity_27
    ,sum(case when activitytypeid = 3 then 1 else 0 end) as thirtyd_activity_3
    ,sum(case when activitytypeid = 300 then 1 else 0 end) as thirtyd_activity_300
    ,sum(case when activitytypeid = 32 then 1 else 0 end) as thirtyd_activity_32
    ,sum(case when activitytypeid = 37 then 1 else 0 end) as thirtyd_activity_37
    ,sum(case when activitytypeid = 38 then 1 else 0 end) as thirtyd_activity_38
    ,sum(case when activitytypeid = 39 then 1 else 0 end) as thirtyd_activity_39
    ,sum(case when activitytypeid = 40 then 1 else 0 end) as thirtyd_activity_40
    ,sum(case when activitytypeid = 400 then 1 else 0 end) as thirtyd_activity_400
    ,sum(case when activitytypeid = 401 then 1 else 0 end) as thirtyd_activity_401
    ,sum(case when activitytypeid = 402 then 1 else 0 end) as thirtyd_activity_402
    ,sum(case when activitytypeid = 403 then 1 else 0 end) as thirtyd_activity_403
    ,sum(case when activitytypeid = 405 then 1 else 0 end) as thirtyd_activity_405
    ,sum(case when activitytypeid = 406 then 1 else 0 end) as thirtyd_activity_406
    ,sum(case when activitytypeid = 407 then 1 else 0 end) as thirtyd_activity_407
    ,sum(case when activitytypeid = 408 then 1 else 0 end) as thirtyd_activity_408
    ,sum(case when activitytypeid = 409 then 1 else 0 end) as thirtyd_activity_409
    ,sum(case when activitytypeid = 41 then 1 else 0 end) as thirtyd_activity_41
    ,sum(case when activitytypeid = 410 then 1 else 0 end) as thirtyd_activity_410
    ,sum(case when activitytypeid = 45 then 1 else 0 end) as thirtyd_activity_45
    ,sum(case when activitytypeid = 46 then 1 else 0 end) as thirtyd_activity_46
    ,sum(case when activitytypeid = 47 then 1 else 0 end) as thirtyd_activity_47
    ,sum(case when activitytypeid = 48 then 1 else 0 end) as thirtyd_activity_48
    ,sum(case when activitytypeid = 6 then 1 else 0 end) as thirtyd_activity_6
    ,sum(case when activitytypeid = 7 then 1 else 0 end) as thirtyd_activity_7
    ,sum(case when activitytypeid = 8 then 1 else 0 end) as thirtyd_activity_8
    ,sum(case when activitytypeid = 9 then 1 else 0 end) as thirtyd_activity_9
from activity a join accounts b on a.leadid = b.leadid
where a.activitydate::date BETWEEN '2016-03-14' AND '2016-04-14'
group by 1
;

create table all_activity as
select
    b.accountsid
    ,sum(case when activitytypeid = 1 then 1 else 0 end) as all_activity_1
    ,sum(case when activitytypeid = 10 then 1 else 0 end) as all_activity_10
    ,sum(case when activitytypeid = 100 then 1 else 0 end) as all_activity_100
    ,sum(case when activitytypeid = 1002 then 1 else 0 end) as all_activity_1002
    ,sum(case when activitytypeid = 1005 then 1 else 0 end) as all_activity_1005
    ,sum(case when activitytypeid = 101 then 1 else 0 end) as all_activity_101
    ,sum(case when activitytypeid = 104 then 1 else 0 end) as all_activity_104
    ,sum(case when activitytypeid = 106 then 1 else 0 end) as all_activity_106
    ,sum(case when activitytypeid = 108 then 1 else 0 end) as all_activity_108
    ,sum(case when activitytypeid = 11 then 1 else 0 end) as all_activity_11
    ,sum(case when activitytypeid = 110 then 1 else 0 end) as all_activity_110
    ,sum(case when activitytypeid = 111 then 1 else 0 end) as all_activity_111
    ,sum(case when activitytypeid = 112 then 1 else 0 end) as all_activity_112
    ,sum(case when activitytypeid = 113 then 1 else 0 end) as all_activity_113
    ,sum(case when activitytypeid = 114 then 1 else 0 end) as all_activity_114
    ,sum(case when activitytypeid = 115 then 1 else 0 end) as all_activity_115
    ,sum(case when activitytypeid = 12 then 1 else 0 end) as all_activity_12
    ,sum(case when activitytypeid = 13 then 1 else 0 end) as all_activity_13
    ,sum(case when activitytypeid = 145 then 1 else 0 end) as all_activity_145
    ,sum(case when activitytypeid = 2 then 1 else 0 end) as all_activity_2
    ,sum(case when activitytypeid = 22 then 1 else 0 end) as all_activity_22
    ,sum(case when activitytypeid = 24 then 1 else 0 end) as all_activity_24
    ,sum(case when activitytypeid = 25 then 1 else 0 end) as all_activity_25
    ,sum(case when activitytypeid = 27 then 1 else 0 end) as all_activity_27
    ,sum(case when activitytypeid = 3 then 1 else 0 end) as all_activity_3
    ,sum(case when activitytypeid = 300 then 1 else 0 end) as all_activity_300
    ,sum(case when activitytypeid = 32 then 1 else 0 end) as all_activity_32
    ,sum(case when activitytypeid = 37 then 1 else 0 end) as all_activity_37
    ,sum(case when activitytypeid = 38 then 1 else 0 end) as all_activity_38
    ,sum(case when activitytypeid = 39 then 1 else 0 end) as all_activity_39
    ,sum(case when activitytypeid = 40 then 1 else 0 end) as all_activity_40
    ,sum(case when activitytypeid = 400 then 1 else 0 end) as all_activity_400
    ,sum(case when activitytypeid = 401 then 1 else 0 end) as all_activity_401
    ,sum(case when activitytypeid = 402 then 1 else 0 end) as all_activity_402
    ,sum(case when activitytypeid = 403 then 1 else 0 end) as all_activity_403
    ,sum(case when activitytypeid = 405 then 1 else 0 end) as all_activity_405
    ,sum(case when activitytypeid = 406 then 1 else 0 end) as all_activity_406
    ,sum(case when activitytypeid = 407 then 1 else 0 end) as all_activity_407
    ,sum(case when activitytypeid = 408 then 1 else 0 end) as all_activity_408
    ,sum(case when activitytypeid = 409 then 1 else 0 end) as all_activity_409
    ,sum(case when activitytypeid = 41 then 1 else 0 end) as all_activity_41
    ,sum(case when activitytypeid = 410 then 1 else 0 end) as all_activity_410
    ,sum(case when activitytypeid = 45 then 1 else 0 end) as all_activity_45
    ,sum(case when activitytypeid = 46 then 1 else 0 end) as all_activity_46
    ,sum(case when activitytypeid = 47 then 1 else 0 end) as all_activity_47
    ,sum(case when activitytypeid = 48 then 1 else 0 end) as all_activity_48
    ,sum(case when activitytypeid = 6 then 1 else 0 end) as all_activity_6
    ,sum(case when activitytypeid = 7 then 1 else 0 end) as all_activity_7
    ,sum(case when activitytypeid = 8 then 1 else 0 end) as all_activity_8
    ,sum(case when activitytypeid = 9 then 1 else 0 end) as all_activity_9
from activity a join accounts b on a.leadid = b.leadid
where a.activitydate::date BETWEEN '2015-04-14' AND '2016-04-14'
group by 1
;

CREATE TABLE driver AS (
  SELECT
    base.*,

    COALESCE(thirtyd_activity_1,0) AS thirtyd_activity_1,
    COALESCE(thirtyd_activity_10,0) AS thirtyd_activity_10,
    COALESCE(thirtyd_activity_100,0) AS thirtyd_activity_100,
    COALESCE(thirtyd_activity_1002,0) AS thirtyd_activity_1002,
    COALESCE(thirtyd_activity_1005,0) AS thirtyd_activity_1005,
    COALESCE(thirtyd_activity_101,0) AS thirtyd_activity_101,
    COALESCE(thirtyd_activity_104,0) AS thirtyd_activity_104,
    COALESCE(thirtyd_activity_106,0) AS thirtyd_activity_106,
    COALESCE(thirtyd_activity_108,0) AS thirtyd_activity_108,
    COALESCE(thirtyd_activity_11,0) AS thirtyd_activity_11,
    COALESCE(thirtyd_activity_110,0) AS thirtyd_activity_110,
    COALESCE(thirtyd_activity_111,0) AS thirtyd_activity_111,
    COALESCE(thirtyd_activity_112,0) AS thirtyd_activity_112,
    COALESCE(thirtyd_activity_113,0) AS thirtyd_activity_113,
    COALESCE(thirtyd_activity_114,0) AS thirtyd_activity_114,
    COALESCE(thirtyd_activity_115,0) AS thirtyd_activity_115,
    COALESCE(thirtyd_activity_12,0) AS thirtyd_activity_12,
    COALESCE(thirtyd_activity_13,0) AS thirtyd_activity_13,
    COALESCE(thirtyd_activity_145,0) AS thirtyd_activity_145,
    COALESCE(thirtyd_activity_2,0) AS thirtyd_activity_2,
    COALESCE(thirtyd_activity_22,0) AS thirtyd_activity_22,
    COALESCE(thirtyd_activity_24,0) AS thirtyd_activity_24,
    COALESCE(thirtyd_activity_25,0) AS thirtyd_activity_25,
    COALESCE(thirtyd_activity_27,0) AS thirtyd_activity_27,
    COALESCE(thirtyd_activity_3,0) AS thirtyd_activity_3,
    COALESCE(thirtyd_activity_300,0) AS thirtyd_activity_300,
    COALESCE(thirtyd_activity_32,0) AS thirtyd_activity_32,
    COALESCE(thirtyd_activity_37,0) AS thirtyd_activity_37,
    COALESCE(thirtyd_activity_38,0) AS thirtyd_activity_38,
    COALESCE(thirtyd_activity_39,0) AS thirtyd_activity_39,
    COALESCE(thirtyd_activity_40,0) AS thirtyd_activity_40,
    COALESCE(thirtyd_activity_400,0) AS thirtyd_activity_400,
    COALESCE(thirtyd_activity_401,0) AS thirtyd_activity_401,
    COALESCE(thirtyd_activity_402,0) AS thirtyd_activity_402,
    COALESCE(thirtyd_activity_403,0) AS thirtyd_activity_403,
    COALESCE(thirtyd_activity_405,0) AS thirtyd_activity_405,
    COALESCE(thirtyd_activity_406,0) AS thirtyd_activity_406,
    COALESCE(thirtyd_activity_407,0) AS thirtyd_activity_407,
    COALESCE(thirtyd_activity_408,0) AS thirtyd_activity_408,
    COALESCE(thirtyd_activity_409,0) AS thirtyd_activity_409,
    COALESCE(thirtyd_activity_41,0) AS thirtyd_activity_41,
    COALESCE(thirtyd_activity_410,0) AS thirtyd_activity_410,
    COALESCE(thirtyd_activity_45,0) AS thirtyd_activity_45,
    COALESCE(thirtyd_activity_46,0) AS thirtyd_activity_46,
    COALESCE(thirtyd_activity_47,0) AS thirtyd_activity_47,
    COALESCE(thirtyd_activity_48,0) AS thirtyd_activity_48,
    COALESCE(thirtyd_activity_6,0) AS thirtyd_activity_6,
    COALESCE(thirtyd_activity_7,0) AS thirtyd_activity_7,
    COALESCE(thirtyd_activity_8,0) AS thirtyd_activity_8,
    COALESCE(thirtyd_activity_9,0) AS thirtyd_activity_9,


    COALESCE(ninetyd_activity_1,0) AS ninetyd_activity_1,
    COALESCE(ninetyd_activity_10,0) AS ninetyd_activity_10,
    COALESCE(ninetyd_activity_100,0) AS ninetyd_activity_100,
    COALESCE(ninetyd_activity_1002,0) AS ninetyd_activity_1002,
    COALESCE(ninetyd_activity_1005,0) AS ninetyd_activity_1005,
    COALESCE(ninetyd_activity_101,0) AS ninetyd_activity_101,
    COALESCE(ninetyd_activity_104,0) AS ninetyd_activity_104,
    COALESCE(ninetyd_activity_106,0) AS ninetyd_activity_106,
    COALESCE(ninetyd_activity_108,0) AS ninetyd_activity_108,
    COALESCE(ninetyd_activity_11,0) AS ninetyd_activity_11,
    COALESCE(ninetyd_activity_110,0) AS ninetyd_activity_110,
    COALESCE(ninetyd_activity_111,0) AS ninetyd_activity_111,
    COALESCE(ninetyd_activity_112,0) AS ninetyd_activity_112,
    COALESCE(ninetyd_activity_113,0) AS ninetyd_activity_113,
    COALESCE(ninetyd_activity_114,0) AS ninetyd_activity_114,
    COALESCE(ninetyd_activity_115,0) AS ninetyd_activity_115,
    COALESCE(ninetyd_activity_12,0) AS ninetyd_activity_12,
    COALESCE(ninetyd_activity_13,0) AS ninetyd_activity_13,
    COALESCE(ninetyd_activity_145,0) AS ninetyd_activity_145,
    COALESCE(ninetyd_activity_2,0) AS ninetyd_activity_2,
    COALESCE(ninetyd_activity_22,0) AS ninetyd_activity_22,
    COALESCE(ninetyd_activity_24,0) AS ninetyd_activity_24,
    COALESCE(ninetyd_activity_25,0) AS ninetyd_activity_25,
    COALESCE(ninetyd_activity_27,0) AS ninetyd_activity_27,
    COALESCE(ninetyd_activity_3,0) AS ninetyd_activity_3,
    COALESCE(ninetyd_activity_300,0) AS ninetyd_activity_300,
    COALESCE(ninetyd_activity_32,0) AS ninetyd_activity_32,
    COALESCE(ninetyd_activity_37,0) AS ninetyd_activity_37,
    COALESCE(ninetyd_activity_38,0) AS ninetyd_activity_38,
    COALESCE(ninetyd_activity_39,0) AS ninetyd_activity_39,
    COALESCE(ninetyd_activity_40,0) AS ninetyd_activity_40,
    COALESCE(ninetyd_activity_400,0) AS ninetyd_activity_400,
    COALESCE(ninetyd_activity_401,0) AS ninetyd_activity_401,
    COALESCE(ninetyd_activity_402,0) AS ninetyd_activity_402,
    COALESCE(ninetyd_activity_403,0) AS ninetyd_activity_403,
    COALESCE(ninetyd_activity_405,0) AS ninetyd_activity_405,
    COALESCE(ninetyd_activity_406,0) AS ninetyd_activity_406,
    COALESCE(ninetyd_activity_407,0) AS ninetyd_activity_407,
    COALESCE(ninetyd_activity_408,0) AS ninetyd_activity_408,
    COALESCE(ninetyd_activity_409,0) AS ninetyd_activity_409,
    COALESCE(ninetyd_activity_41,0) AS ninetyd_activity_41,
    COALESCE(ninetyd_activity_410,0) AS ninetyd_activity_410,
    COALESCE(ninetyd_activity_45,0) AS ninetyd_activity_45,
    COALESCE(ninetyd_activity_46,0) AS ninetyd_activity_46,
    COALESCE(ninetyd_activity_47,0) AS ninetyd_activity_47,
    COALESCE(ninetyd_activity_48,0) AS ninetyd_activity_48,
    COALESCE(ninetyd_activity_6,0) AS ninetyd_activity_6,
    COALESCE(ninetyd_activity_7,0) AS ninetyd_activity_7,
    COALESCE(ninetyd_activity_8,0) AS ninetyd_activity_8,
    COALESCE(ninetyd_activity_9,0) AS ninetyd_activity_9,

    COALESCE(select_tickets,0) AS select_tickets,
    COALESCE(value_tickets,0) AS value_tickets,
    COALESCE(marquee_tickets,0) AS marquee_tickets,
    COALESCE(supersaver_tickets,0) AS supersaver_tickets,
    COALESCE(preseason_tickets,0) AS preseason_tickets,
    COALESCE(premier_tickets,0) AS premier_tickets,
    COALESCE(elite_tickets,0) AS elite_tickets,
    COALESCE(other_tickets,0) AS other_tickets,
    COALESCE(select_tickets_90d,0) AS select_tickets_90d,
    COALESCE(value_tickets_90d,0) AS value_tickets_90d,
    COALESCE(marquee_tickets_90d,0) AS marquee_tickets_90d,
    COALESCE(supersaver_tickets_90d,0) AS supersaver_tickets_90d,
    COALESCE(preseason_tickets_90d,0) AS preseason_tickets_90d,
    COALESCE(premier_tickets_90d,0) AS premier_tickets_90d,
    COALESCE(elite_tickets_90d,0) AS elite_tickets_90d,
    COALESCE(other_tickets_90d,0) AS other_tickets_90d,
    COALESCE(select_tickets_30d,0) AS select_tickets_30d,
    COALESCE(value_tickets_30d,0) AS value_tickets_30d,
    COALESCE(marquee_tickets_30d,0) AS marquee_tickets_30d,
    COALESCE(supersaver_tickets_30d,0) AS supersaver_tickets_30d,
    COALESCE(preseason_tickets_30d,0) AS preseason_tickets_30d,
    COALESCE(premier_tickets_30d,0) AS premier_tickets_30d,
    COALESCE(elite_tickets_30d,0) AS elite_tickets_30d,
    COALESCE(other_tickets_30d,0) AS other_tickets_30d,


    COALESCE(tickets_purchased, 0) AS tickets_purchased

  FROM
    all_activity AS base
  LEFT JOIN
    thirtyd_activity AS thirtyd_activity
  ON
    base.accountsid=thirtyd_activity.accountsid
  LEFT JOIN
    ninetyd_activity AS ninetyd_activity
  ON
    base.accountsid=ninetyd_activity.accountsid
  LEFT JOIN
    past_trxn_trending AS trxn
  ON
    trxn.accountsid=base.accountsid
  LEFT JOIN
    future_transactions AS future
  ON
    base.accountsid = future.accountsid
)
;



drop table detailed_driver;
create table detailed_driver as (
select a.accountsid,annual_income,eduinfo,agerange,marital_status,gender,occupation,b.tickets_purchased
from (select accountsid,annual_income,eduinfo,agerange,marital_status,gender,occupation from accounts group by 1,2,3,4,5,6,7) as a
join final_driver as b
on a.accountsid=b.accountsid
)


create table driver_meta as (
SELECT
	driver.*,
	case
		when eduinfo='High School' then 1
		when eduinfo='Completed High School' then 2
		when eduinfo='College' then 3
		when eduinfo='Completed College' then 4
		when eduinfo='Completed Graduate School' then 5
		else 0
	end as eduinfo,
	case
		when occupation='Professional / Technical' then 1
		when occupation='Professional/Technical' then 1
		when occupation='Clerical / White Collar' then 2
		when occupation='Craftsman / Blue Collar' then 3
		when occupation='Administration / Managerial' then 4
		when occupation='Sales / Service' then 4
		when occupation='Medical Professional' then 5
		when occupation='Retired' then 6
		when occupation like '%Self Employed%' then 6
		when occupation='Student' then 6
		when occupation='Farmer' then 6
		when occupation='President' then 7
		when occupation='CEO' then 7
		when occupation='Vice President' then 7
		when occupation='President/CEO' then 7
		when occupation='President & CEO' then 7
		when occupation='President & Ceo' then 7
		when occupation='V Pres' then 7
		when occupation='Pres' then 7
		when occupation='Board Member' then 7
		when occupation='Chief Executive Officer' then 7
		else 8
	end as occupation,
	case
		when annual_income = 'Less than $15,000' then 1
		when annual_income = 'LESS THAN $15,000' then 1
		when annual_income = 'Less Than $15,000' then 1
		when annual_income = '$15,000 - $19,999' then 1
		when annual_income = '$20,000 - $29,999' then 1
		when annual_income = '$25,000 - $29,999' then 1
		when annual_income = '$30,000 - $39,999' then 2
		when annual_income = '$40,000 - $49,999' then 2
		when annual_income = '$50,000 - $74,999' then 3
		when annual_income = '$75,000 - $99,999' then 3
		when annual_income = '$100,000 - $124,999' then 4
		when annual_income = 'Greater than $124,999' then 5
		when annual_income = 'GREATER THAN $124,999' then 5
		when annual_income = 'Greater Than $124,999' then 5
		when annual_income = '$100,000 - $149,999' then 5
		else 6
	end as annual_income
from final_driver as driver
join (select * from detailed_driver where eduinfo is not null and annual_income is not null and occupation is not null) as detl
on driver.accountsid=detl.accountsid
)
