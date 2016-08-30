all_org_ids = [179]
admin = User.find_by_username("admin")
bills = CarryingBill.where(:to_org_id => all_org_ids ,:state => 'deliveried',:type => ['ComputerBill', 'HandBill', 'ReturnBill',  'AutoCalculateComputerBill'],:completed => false )
g_bills = bills.group_by {|b| b.deliver_info.deliver_date}
g_bills.each do |d,bills|
  bill_ids = bills.map {|bill| bill.id}
  settlement = Settlement.new(:bill_date => d,:org_id => 179,:user_id => admin.id,:note => "系统自动生成结算清单")
  settlement.carrying_bill_ids = bill_ids
  #处理结算清单
  settlement.process
end
