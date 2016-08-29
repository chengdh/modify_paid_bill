from_summary_org_id = 2
ref_date = '2016-08-21'
admin = User.find_by_username("admin")
from_summary_org = Org.find(from_summary_org_id)
from_child_org_ids = from_summary_org.children.map {|c| c.id}
from_all_org_ids = from_child_org_ids + [from_summary_org_id]

sets_ids = %w(
354
355
356
357
358
359
360
361
362
363
364
365
366
367
368
369
370
371
372
373
374
375
376
377
378
379
380
381
382
383
384
385
386
387
388
389
)

Org.branch_list.each do |b|
  to_child_branch_ids = Org.branch_list_ids(b.id)
  to_all_org_ids = to_child_branch_ids + [b.id]
  bills = CarryingBill.search(:to_org_id_in => to_all_org_ids ,
  :from_org_id_in => from_all_org_ids,
  :state_eq => 'settlemented',
  :settlement_id_in => sets_ids,
  :type_in => ['ComputerBill', 'HandBill', 'ReturnBill',  'AutoCalculateComputerBill'],
  :bill_no_ni => ['9210377','9202744','1202939','9210383','9202738','9202740','9202739','9202737'],
  :completed_eq => false )

  if bills.present?
    bill_ids = bills.map {|bill| bill.id}
    refund = Refound.new(:from_org_id => b.id,:to_org_id => from_summary_org_id,:user_id => admin.id,:note => "系统自动生成返款清单")
    refund.carrying_bill_ids = bill_ids
    refund.process
  end
end
