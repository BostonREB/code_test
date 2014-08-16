require 'csv'

products = {}
CSV.foreach("products.tab", { :col_sep => "\t" }) do |row|
  name, category = row
  next if (name == nil) || (name == "Name")
  products[name] = category
end

sales = {}
CSV.foreach("sales.tab", { :col_sep => "\t" }) do |row|
  name, sales_volume = row
  next if (name == nil) || (name == "Name")
  sales[name] = sales_volume
end

all_products = sales.merge(products){|key, sales_volume, category| [category, sales_volume]}

#Find Top Five Categories By Sales
categories = products.values.uniq
categories_with_sales = all_products.values

all_products_by_category = all_products.sort_by{|product, info| info[0]}
categories_with_sales = all_products.values

# group_sales = []
# total_item_sales = 0
# categories.each do |category|
#   categories_with_sales.each do |item|
#     if item[0] == category
#       hash = Hash[category, item[1]]
#       group_sales << hash
#     end
#   end
# end
# puts "#{group_sales}"


#Group Sales by Category
group_sales = []
total_item_sales = 0
categories.each do |category|
  categories_with_sales.each do |item|
    if item[0] == category
      hash = Hash[category, item[1].to_f]
      group_sales << hash
    end
  end
end
puts "#{group_sales.first}"


#Find Top selling Candy
all_candy = all_products.select{|product, info| info[0] == "Candy"}
all_candy = all_candy.sort_by{|product, info| info[1]}
top_candy = all_candy.last
puts "The top selling candy is #{top_candy[0]}"
