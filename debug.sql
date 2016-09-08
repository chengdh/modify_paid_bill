SELECT *
FROM  `carrying_bills`
WHERE bill_date >=  '2016-05-01'
AND state
IN (
'loaded',  'shipped',  'reached',  'distributed'
)
AND load_list_id IS NULL ;

SELECT *
FROM  `carrying_bills`
WHERE bill_date >=  '2016-05-01'
AND state
IN (
'loaded',  'shipped',  'reached',  'distributed'
)
AND load_list_id IS NULL ;

SELECT bill_date,type,bill_no FROM `carrying_bills` WHERE bill_date >= '2016-05-01'
AND state in ('settlemented')
AND settlement_id is null

SELECT bill_date,
TYPE , bill_no
FROM  `carrying_bills`
WHERE bill_date >=  '2016-05-01'
AND state
IN (
'payment_listed'
)
AND payment_list_id IS NULL;

SELECT * FROM carrying_bills WHERE
state = 'refunded'
AND type in ('InnerTransitBill','HandInnerTransitBill','InnerTransitReturnBill')
AND bill_date >= '2016-05-01'
AND bill_date <= '2016-08-20';

SELECT * FROM carrying_bills WHERE
state = 'settlemented'
AND type in ('InnerTransitBill','HandInnerTransitBill','InnerTransitReturnBill')
AND bill_date >= '2016-05-01'
AND bill_date <= '2016-08-20'
AND settlement_id IS null
ORDER BY bill_date DESC;

-- 查1-18号的已返款票据
SELECT bill_date,bill_no,b.name,c.name,pay_type,carrying_fee,goods_fee,from_short_carrying_fee,to_short_carrying_fee
FROM carrying_bills a,orgs b,orgs c
WHERE 1 = 1
AND a.from_org_id = b.id
AND a.to_org_id = c.id
AND a.bill_date >='2016-08-01'
AND a.bill_date <= '2016-08-18'
AND a.deliver_info_id IS NULL
AND a.state in ('refunded','refunded_confirmed','payment_listed','paid','posted')
AND a.type in ('ComputerBill', 'HandBill', 'ReturnBill',  'AutoCalculateComputerBill')
AND a.from_org_id in (select id from orgs WHERE parent_id = 2)
ORDER BY a.to_org_id
INTO OUTFILE '/tmp/bills_1_18.csv'
FIELDS TERMINATED BY ',';

-- 查询7月转账票据
SELECT a.bill_date,a.bill_no,b.name,c.name,pay_type,carrying_fee,goods_fee,from_short_carrying_fee,to_short_carrying_fee
FROM carrying_bills a,orgs b,orgs c,imp_no2 d
WHERE 1 = 1
AND a.from_org_id = b.id
AND a.to_org_id = c.id
AND a.bill_date >='2016-06-01'
AND a.bill_date <= '2016-07-31'
AND a.type in ('ComputerBill', 'HandBill', 'ReturnBill',  'AutoCalculateComputerBill')
AND a.from_org_id in (select id from orgs WHERE parent_id = 2)
AND a.bill_no = d.bill_no
ORDER BY a.to_org_id
INTO OUTFILE '/tmp/bills_0601_0731.csv'
FIELDS TERMINATED BY ',';

SELECT a.from_customer_name,b.name FROM `carrying_bills` a,customers b
where a.from_customer_id = b.id
and a.from_customer_id is not null
and a.from_customer_name <> b.name;
