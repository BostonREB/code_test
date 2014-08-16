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


#Sales by Category
group_sales = []
sales_volume = {}
categories.each do |category|
  categories_with_sales.each do |item|
    if item[0] == category
      hash = Hash[category, item[1].to_f]
      group_sales << hash
    end
  end
  sales_volume[category] = group_sales.select {|h| h[category]}.collect {|h| h[category]}
end

total_sales = {}
sales_volume.each_pair do |category, sales_value|
  sales_value = sales_value.inject{|sum,x| sum + x }
  total_sales[category] = sales_value
end
top_categories = total_sales.sort_by{|category, sales_value| sales_value}.reverse!
puts "The top five categories by sales are the following:"
top_categories.first(5).each do |category|
  puts category
  puts
end

#Find Top selling Candy
all_candy = all_products.select{|product, info| info[0] == "Candy"}
all_candy = all_candy.sort_by{|product, info| info[1]}.reverse!
puts "The top selling candy is the following:"
puts all_candy.first[0]
