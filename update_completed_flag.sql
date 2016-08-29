#现金付/回执付/无代收货款,自动置结束标记
UPDATE carrying_bills
SET completed = 1
WHERE
state = 'settlemented'
AND pay_type in ('RE','CA')
AND goods_fee > 0
AND completed = 0;

#现金票,已结帐
UPDATE carrying_bills
SET completed = 1
WHERE
state = 'posted'
AND pay_type in ('CA')
AND goods_fee > 0
AND completed = 0;


#转账提款

#已退货票据
UPDATE carrying_bills
SET completed = 1
WHERE
state = 'returned'
AND completed = 0;

#提货付运费且货款为0,收款清单确认后,自动完成
UPDATE carrying_bills
SET completed = 1
WHERE
state = 'refunded_comfirmed'
AND pay_type in ('TH')
AND goods_fee = 0
AND completed = 0;

#作废,注销票 设置为已完成

UPDATE carrying_bills
SET completed = 1
WHERE
state in ('invalided','canceled')
AND completed = 0;
