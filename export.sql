-- 1 导出il_yanzhao_import_production 2016-01-01后的数据
-- SELECT * FROM carrying_bills where SUBSTRING(goods_no,1,6) >= '160101' INTO OUTFILE 'carrying_bills_after_20160101' FIELDS TERMINATED BY ',';

-- 导入数据
-- LOAD DATA INFILE 'carrying_bills_after_20160101' REPLACE INTO TABLE carrying_bills FIELDS TERMINATED BY ',';
-- 导出il_yanzhao_new_production数据
mysqldump -uroot -p il_yanzhao_new_production > il_yanzhao_new_production_201608271218.sql;

-- 导出2016-05-01 至 2016-08-20的运单数据
SELECT *
FROM carrying_bills
WHERE bill_date >=  '2016-05-01'
AND bill_date <=  '2016-08-20'
INTO OUTFILE '/tmp/carrying_bills_20160501_20160820' FIELDS TERMINATED BY ',';

-- 自il_yanzhao_new_production中导出所有已操作过的数据
SELECT * FROM carrying_bills
WHERE bill_date <= '2016-08-20'
AND bill_date >= '2016-05-01'
AND deliver_info_id IS NOT NULL
INTO OUTFILE '/tmp/carrying_bills_operated_before_20160820' FIELDS TERMINATED BY ',';


-- STEP1 导入文件到il_yanzhao_new_production中去
LOAD DATA INFILE '/tmp/carrying_bills_20160501_20160820' REPLACE INTO TABLE carrying_bills FIELDS TERMINATED BY ',';

-- 备份Il_yanzhao_new_production数据库
mysqldump -uroot -p il_yanzhao_new_production > il_yanzhao_new_production_step1.sql;

-- STEP2 导入已操作数据到il_yanzhao_new_production
LOAD DATA INFILE '/tmp/carrying_bills_operated_before_20160820' REPLACE INTO TABLE carrying_bills FIELDS TERMINATED BY ',';

-- 备份Il_yanzhao_new_production数据库
mysqldump -uroot -p il_yanzhao_new_production > il_yanzhao_new_production_step2.sql;

-- STEP3 删除掉因bill_no 相同 但是 completed 不同而导致票据重复的问题
-- SELECT bill_no FROM carrying_bills WHERE bill_date >= '2016-01-01' GROUP BY bill_no HAVING COUNT(*) > 1
-- INTO OUTFILE '/tmp/carrying_bills_dups' FIELDS TERMINATED BY ',';

mysqldump -uroot -p il_yanzhao_new_production > il_yanzhao_new_production_step3.sql;

-- 重新计算手续费
bills = CarryingBill.search(:bill_date_gte => '2016-05-01',:bill_date_lte => '2016-08-20')
bills.each do |b|
  fee = ConfigCash.default_hand_fee(b.goods_fee)
  b.k_hand_fee = fee.ceil
  b.save!
end ; nil

UPDATE carrying_bills SET k_hand_fee = ceil(goods_fee*0.002);

OK
-- 处理在途票据，已到货 票据状态修改为已分货
-- 内部中转 在途 中转到货  中转发货 已到货 状态修改为已分货
-- 同城 在途 已到货 状态修改为已分货
UPDATE carrying_biils
  SET state = 'distributed'
WHERE state in ('loaded','shipped','transit_reached','transit_shipped','reached')
AND bill_date >= '2016-05-01'
AND bill_date <= '2016-08-20'
AND type not in ('TransitBill','HandTransitBill','OutterTransitReturnBill');

OK

--FIXME 手动生成 修改已提货票据为已结算
UPDATE carrying_bills set state = 'settlemented'
WHERE state = 'deliveried'
AND bill_date >= '2016-05-01'
AND bill_date <= '2016-08-20';

-- 修改已结算票据状态为已返款
UPDATE carrying_bills set state = 'refunded'
WHERE state = 'settlemented'
AND bill_date >= '2016-05-01'
AND bill_date <= '2016-08-20' and (pay_type = 'TH' or goods_fee > 0);

-- 分公司 已返款状态的票据自动生成20号返款清单
Refound.generate_refund_for_branch_org(2,'2016-08-20') ; nil
OK

-- 返程货 已返款状态的票据自动生成返款清单
Refound.generate_refund_for_summary_org_for_restore(2,'2016-08-20') ; nil
ok


-- 分公司已提货 票据  自动生成21号结算清单
Refound.generate_refund_for_branch_org_with_state_deliveried(2,'2016-08-21') ; nil

-- 内部中转 已返款状态的票据自动生成返款清单
-- 外部中转 已返款状态的票据自动生成返款清单
-- 同城 已返款状态的票据自动生成返款清单

-- 外部中转票 外部中转在途 修改为

-- 批量处理已转账的票据,直接处理成已结帐状态,备注转账日期

-- 原运费为空的数据，更新为0
UPDATE carrying_bills
  set original_carrying_fee = carrying_fee
  WHERE original_carrying_fee IS NULL
  AND bill_date >= '2016-05-01'
  AND bill_date <= '2016-08-20';


SELECt bill_no
FROM  `carrying_bills`
WHERE
bill_date >= '2016-05-01'
AND bill_date < '2016-08-21'
-- and refound_id is not null
group by bill_no having count(*) > 1
order by bill_no;

SELECt bill_no
FROM  `carrying_bills`
WHERE
state = 'refunded_confirmed'
and goods_fee = 0
and pay_type = 'TH'
and completed = 1

-- 更新状态不正确的数据
UPDATE  `carrying_bills`
  SET completed = 1
  WHERE goods_fee = 0
  and state='refunded_confirmed'
  and carrying_fee > 0
  and pay_type = 'TH'
  AND completed = 0;

UPDATE  `carrying_bills`
  SET completed = 1
  WHERE goods_fee = 0
  and state='settlemented'
  and carrying_fee > 0
  and pay_type in ('CA','RE')
  AND completed = 0;
