#coding: utf-8
#内部中转,已返款的生成返款清单
summary_org_id = 2
refund_date = '2016-08-20'
admin = User.find_by_username("admin")
yard_orgs = Org.where(:is_active => true,:is_yard => true)
orgs = Org.where(:is_active => true,:is_yard => false,:is_summary => false)

#中转部到分离处或分公司或分公司
yard_orgs.each do |y|
  orgs.each do |o|
    to_child_org_ids = Org.branch_list_ids(o.id)
    to_all_org_ids = to_child_org_ids + [o.id]

    bills = CarryingBill.search(
    :from_org_id_in => to_all_org_ids,
    :transit_org_id_eq => y.id,
    :state_in => ['refunded'],
    :type_in =>  ['TransitBill','HandTransitBill','OutterTransitReturnBill'],
    :bill_date_gte => '2016-05-01',
    :bill_date_lte => '2016-08-20',
    :refound_id_is_null => true,
    :completed_eq => false ).all


    if bills.present?
      bill_ids = bills.map {|bill| bill.id}
      refund = OutterTransitRefund.new(:state => 'refunded',:from_org_id => y.id,:to_org_id => o.id,:bill_date => refund_date,:user_id => admin.id,:note => "系统自动生成返款清单")
      refund.carrying_bill_ids = bill_ids
      refund.save!
    end
  end
end
