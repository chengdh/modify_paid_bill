#coding: utf-8
#导入已付款的票据
dir = "/home/lmis/restore_code/modify_paid_bill/6mth_paid_bills"
#dir="/Users/chengdh/modify_paid_bill/paid_file"
#dir = "/home/lmis/restore_code/modify_paid_bill/paid_file"
files_count = 0
Dir.foreach(dir) do |item|
   next if item == '.' or item == '..' or item == '.DS_Store'
   #puts item
   files_count += 1
   lines = []
   file = "#{dir}/#{item}"
   #file = "/home/lmis/restore_code/modify_paid_bill/paid_file/test.txt"
   File.open(file, "r") do |f|
     f.each_line do |line|
       lines << line.strip!
     end
     #puts lines
     #更新数据
     paid_date = lines[0]
     bill_nos = lines[1,lines.size - 1]
     CarryingBill.update_all("state = 'posted',completed = 1,note ='提款日期:#{paid_date}'",["bill_no in (?)",bill_nos])
  end
  puts "file count: #{files_count}"
end
