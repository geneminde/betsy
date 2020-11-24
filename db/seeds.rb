# frozen_string_literal: true
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
require 'csv'

CATEGORY_FILE = Rails.root.join('db', 'seed_data', 'categories.csv')
puts "Loading raw media (category) data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.name = row['name']
  successful = category.save
  if !successful
    category_failures << category
    puts "Failed to save work: #{category.inspect}"
  else
    puts "Created work: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"

USER_FILE = Rails.root.join('db', 'seed_data', 'users.csv')
user_upload_failures = []

CSV.foreach(USER_FILE, :headers => true) do |row|
  user = User.new
  user.username = row['username']
  user.email = row['email']
  user.uid = row['uid'].to_i
  user.provider = row['provider']

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
PRODUCT_FILE = Rails.root.join('db', 'seed_data', 'products.csv')
product_upload_failures = []

CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.name = row['name']
  product.price = rand(10..1000)
  product.photo_url = row['photo']
  product.description = row['description']
  product.quantity = rand(0..100)
  product.is_retired = [true, false].sample
  product.available = product.quantity.zero? || product.is_retired ? false : true
  product.user_id = row['user_id']
  product.category_ids = row['category_id'].split(';')

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
  order.date_placed = order.status == 'pending' ? nil : Faker::Date.backward

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

  order_item.quantity = rand(1..5)
  order_item.order_id = rand(1..40)
  order_item.product_id = rand(1..44)
  order_item.shipped = [true, false].sample

  successful = order_item.save
  if !successful
    order_item_upload_failures << order_item
    puts "Failed to save order item: #{order_item.inspect}"
  else
    puts "Created order item: #{order_item.inspect}"
  end
end

########################################################

review_upload_failures = []
100.times do
  review = Review.new

  review.rating = rand(1..5)
  review.author_name = [Faker::Name.name.to_s, nil].sample
  review.product_id = rand(1..199)
  review.review_text = ["#{Product.find_by(id: review.product_id).name} is super rad", nil].sample

  successful = review.save
  if !successful
    review_upload_failures << review
    puts "Failed to save review: #{review.inspect}"
  else
    puts "Created review: #{review.inspect}"
  end
end

puts 'FINAL SUMMARY:'

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"

puts "Added #{User.count} user records"
puts "#{user_upload_failures.size} users failed to save"

puts "Added #{Product.count} product records"
puts "#{product_upload_failures.size} products failed to save"

puts "Added #{Order.count} order records"
puts "#{order_upload_failures.size} orders failed to save"

puts "Added #{OrderItem.count} order_items records"
puts "#{order_item_upload_failures.size} order items failed to save"


# failures = [user_upload_failures, product_upload_failures, order_upload_failures, order_item_upload_failures]
# failures.each do |model_failures|
#   next if model_failures.empty?
#   model_failures.each do |record|
#     puts record.errors.messages
#   end
# end

puts 'done'