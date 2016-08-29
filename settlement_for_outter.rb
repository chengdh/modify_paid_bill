#coding: utf-8
set_date = '2016-08-21'

admin = User.find_by_username("admin")
#只生成中转部的结算清单
orgs = Org.where(:is_active => true,:is_yard => true)
orgs.each do |b|
  bills = CarryingBill.search(:transit_org_id_eq => b.id ,
  :state_eq => 'settlemented',
  :type_in =>  ['TransitBill','HandTransitBill','OutterTransitReturnBill'],
  :bill_date_gte => '2016-05-01',
  :bill_date_lte => '2016-08-20',
  :settlement_id_is_null => true,
  :completed_eq => false ).all

  bills.each do |the_bill|
    puts the_bill.bill_no unless the_bill.valid?
  end
  if bills.present?
    bill_ids = bills.map {|bill| bill.id}
    settlement = OutterTransitSettlement.new(
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
