#coding: utf-8
#生成总部返款单
to_summary_org_id = 2
refund_date = '2016-08-20'
admin = User.find_by_username("admin")

to_department_ids = Org.branch_list_ids(to_summary_org_id)

from_branches = Org.branch_list
from_branches.each do |b|
  from_child_branch_ids = Org.branch_list_ids(b.id)
  from_all_org_ids = from_child_branch_ids + [b.id]
  bills = CarryingBill.search(:from_org_id_in => from_all_org_ids ,
  :to_org_id_in => to_department_ids,
  :state_eq => 'refunded',
  :bill_date_gte => '2016-05-01',
  :bill_date_lte => '2016-08-20',
  :refound_id_is_null => true,
  :type_in => ['ComputerBill', 'HandBill', 'ReturnBill',  'AutoCalculateComputerBill'],
  :completed_eq => false ).all

  if bills.present?
    bill_ids = bills.map {|bill| bill.id}
    refund = Refound.new(:state => 'refunded',:from_org_id => to_summary_org_id,:to_org_id => b.id,:bill_date => refund_date,:user_id => admin.id,:note => "系统自动生成返款清单")
    refund.carrying_bill_ids = bill_ids
    refund.save!
  end
end
