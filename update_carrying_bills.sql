-- select CONCAT('20',SUBSTRING(goods_no,1,2),'-',SUBSTRING(goods_no,3,2) ,'-' ,SUBSTRING(goods_no,5,2)) from carrying_bills WHERE SUBSTRING(goods_no,1,6) >= '160401';
update carrying_bills
  set
    bill_date = CONCAT('20',SUBSTRING(goods_no,1,2),'-',SUBSTRING(goods_no,3,2) ,'-' ,SUBSTRING(goods_no,5,2)),
    user_id = 1,
    created_at = NOW(),
    updated_at = NOW(),
    original_bill_id = NULL,
    load_list_id = NULL,
    distribution_list_id = NULL,
    deliver_info_id = NULL,
    settlement_id = NULL,
    refound_id = NULL,
    payment_list_id = NULL,
    pay_info_id = NULL,
    post_info_id = NULL,
    k_hand_fee = NULL,
    transit_info_id = NULL,
    transit_deliver_info_id = NULL,
    print_counter = 0,
    goods_cat_id = NULL,
    th_bill_print_count = 0;

  update carrying_bills
    set additional_state = 'draft'
    where additional_state not in ('detained','lossed') or additional_state is null;
--    and SUBSTRING(goods_no,1,6) >= '160401';

  update carrying_bills
    set from_short_state = 'draft'
    where from_short_state not in ('draft','saved','offed') or from_short_state is null;
--    and SUBSTRING(goods_no,1,6) >= '160401';

    update carrying_bills
    set to_short_state = 'draft'
    where to_short_state not in ('draft','saved','offed') or to_short_state is null;
--    and SUBSTRING(goods_no,1,6) >= '160401';


    update carrying_bills
      set k_hand_fee = 0.0
    where k_hand_fee is null;
--    and SUBSTRING(goods_no,1,6) >= '160401';


    update carrying_bills
      set transit_carrying_fee = 0.0
    where transit_carrying_fee is null;
--    and SUBSTRING(goods_no,1,6) >= '160401';
