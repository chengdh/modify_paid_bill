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
