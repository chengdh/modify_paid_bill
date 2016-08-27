#coding: utf-8
#内部中转,已返款的生成返款清单
summary_org_id = 2
refund_date = '2016-08-20'
admin = User.find_by_username("admin")
summary_org = Org.find(summary_org_id)
dep_ids = summary_org.children.map {|c| c.id}
f_deps = summary_org.children
t_deps = summary_org.children

branchs = Org.branch_list
branch_ids = Org.branch_list_ids

#分理处到分分理处
f_deps.each do |f|
  t_deps.each do |t|
    bills = CarryingBill.search(
    :from_org_id_eq => f.id,
    :to_org_id_eq => t.id,
    :state_in => ['refunded'],
    :type_in =>  ['LocalTownBill','HandLocalTownBill','LocalTownReturnBill'],
    :bill_date_gte => '2016-05-01',
    :bill_date_lte => '2016-08-20',
    :refound_id_is_null => true,
    :completed_eq => false ).all


    if bills.present?
      bill_ids = bills.map {|bill| bill.id}
      refund = LocalTownRefund.new(:state => 'refunded',:from_org_id => t.id,:to_org_id => f.id,:bill_date => refund_date,:user_id => admin.id,:note => "系统自动生成返款清单")
      refund.carrying_bill_ids = bill_ids
      refund.save!
    end
  end
end
