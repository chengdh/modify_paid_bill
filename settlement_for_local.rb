#coding: utf-8
set_date = '2016-08-21'

admin = User.find_by_username("admin")
#只是生成分理处及一级分公司的结算员交款清单
orgs = Org.department_list

orgs.each do |b|
  bills = CarryingBill.search(:to_org_id_eq => b.id,
  :state_eq => 'settlemented',
  :type_in =>  ['LocalTownBill','HandLocalTownBill','LocalTownReturnBill'],
  :bill_date_gte => '2016-05-01',
  :bill_date_lte => '2016-08-20',
  :settlement_id_is_null => true,
  :completed_eq => false ).all
  bills.each do |the_bill|
    puts the_bill.bill_no unless the_bill.valid?
  end
  if bills.present?
    bill_ids = bills.map {|bill| bill.id}
    settlement = LocalTownSettlement.new(
    :bill_date => set_date,
    :state => "settlemented",
    :org_id => b.id,
    :user_id => admin.id,
    :state => 'settlemented',
    :note => "系统自动生成结算清单")
    settlement.carrying_bill_ids = bill_ids
    settlement.save!
  end
end
