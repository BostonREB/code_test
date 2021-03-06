require 'csv'

#Build full product list including sales and cetegories
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

category_sales = []
sales_volume = {}
total_sales = {}
categories.each do |category|
  products_by_category = all_products.select{|product, info| info[0] == category}
  item_category_with_sales = products_by_category.values
  item_category_with_sales.each do |item|
    item_sales = Hash[category, item[1].to_f]
    category_sales << item_sales
    sales_volume[category] = category_sales.select {|h| h[category]}.collect {|h| h[category]}
  end
  sales_volume.each_pair do |category, sales_value|
    sales_value = sales_value.inject{|sum,x| sum + x }
    total_sales[category] = sales_value
  end
end

total_sales = total_sales.sort_by{|category, sales_volume| sales_volume}.reverse!
puts "The top five categories by sales are the following:"
total_sales.first(5).each do |category|
  puts category
  puts
end

#Find Top selling Candy
all_candy = all_products.select{|product, info| info[0] == "Candy"}
all_candy = all_candy.sort_by{|product, info| info[1]}.reverse!
puts "The top selling candy is the following:"
puts all_candy.first[0]
