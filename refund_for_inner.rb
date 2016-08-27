#coding: utf-8
#内部中转,已返款的生成返款清单
summary_org_id = 2
refund_date = '2016-08-20'
admin = User.find_by_username("admin")

from_branchs = Org.branch_list
to_branchs = Org.branch_list

#分公司到分公司
from_branchs.each do |f|
  from_child_branch_ids = Org.branch_list_ids(f.id)
  from_all_org_ids = from_child_branch_ids + [f.id]

  to_branchs.each do |t|
    to_child_branch_ids = Org.branch_list_ids(t.id)
    to_all_org_ids = to_child_branch_ids + [t.id]

    bills = CarryingBill.search(
    :from_org_id_in => from_all_org_ids ,
    :to_org_id_in => to_all_org_ids ,
    :state_in => ['refunded'],
    :type_in =>  ['InnerTransitBill','HandInnerTransitBill','InnerTransitReturnBill'],
    :bill_date_gte => '2016-05-01',
    :bill_date_lte => '2016-08-20',
    :refound_id_is_null => true,
    :completed_eq => false ).all


    if bills.present?
      bill_ids = bills.map {|bill| bill.id}
      refund = InnerTransitRefund.new(:state => 'refunded',:from_org_id => t.id,:to_org_id => f.id,:bill_date => refund_date,:user_id => admin.id,:note => "系统自动生成返款清单")
      refund.carrying_bill_ids = bill_ids
      refund.save!
    end
  end
end
