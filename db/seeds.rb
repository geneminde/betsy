# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

include ActiveSupport::NumberHelper
require 'faker'
require 'date'

user_upload_failures = []
50.times do |num|
  user = User.new

  user.username = "user#{num}"
  user.email = Faker::Internet.email.to_s
  user.uid = rand(1_111_111..9_999_999)
  user.provider = 'github'

  successful = user.save
  if !successful
    user_upload_failures << user
    puts "Failed to save user: #{user.inspect}"
  else
    puts "Created user: #{user.inspect}"
  end
end

puts "Added #{User.count} user records"
puts "#{user_upload_failures.size} users failed to save"

#########################################################

product_upload_failures = []
200.times do
  product = Product.new

  product.name = Faker::Movies::HitchhikersGuideToTheGalaxy.planet.to_s

  product.price = rand(10..1000)
  product.photo_url = 'https://mir-s3-cdn-cf.behance.net/project_modules/1400/4b0f7269010315.5b71b33089965.jpg'
  product.description = Faker::Movies::HitchhikersGuideToTheGalaxy.quote.to_s
  product.quantity = rand(1000)
  product.available = [true, false].sample
  product.user_id = rand(1..19)

  successful = product.save
  if !successful
    product_upload_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_upload_failures.size} products failed to save"

#########################################################

order_upload_failures = []
status = %w[pending paid complete cancelled]
50.times do
  order = Order.new

  order.status = status.sample.to_s
  order.customer_name = Faker::Name.name.to_s
  order.shipping_address = Faker::Address.full_address.to_s
  order.cardholder_name = Faker::Name.name.to_s
  order.cc_number = rand(1111..9999)
  order.cc_expiry = (Date.today + 365).strftime('%m/%Y').to_s
  order.ccv = rand(100..999)
  order.billing_zip = rand(10_000..99_999)

  successful = order.save
  if !successful
    order_upload_failures << order
    puts "Failed to save order: #{order.inspect}"
  else
    puts "Created order: #{order.inspect}"
  end
end

puts "Added #{Order.count} order records"
puts "#{order_upload_failures.size} orders failed to save"

########################################################

order_item_upload_failures = []
100.times do
  order_item = OrderItem.new

  order_item.quantity = rand(1..10)
  order_item.order_id = rand(1..40)
  order_item.product_id = rand(1..99)

  successful = order_item.save
  if !successful
    order_item_upload_failures << order_item
    puts "Failed to save order item: #{order_item.inspect}"
  else
    puts "Created order item: #{order_item.inspect}"
  end
end

puts "Added #{OrderItem.count} order_items records"
puts "#{order_item_upload_failures.size} order items failed to save"

puts 'done'