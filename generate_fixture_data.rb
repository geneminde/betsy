require 'yaml'
require 'faker'
require 'date'


# Orders
status = ["pending", "paid", "complete", "cancelled"]
10.times do |i|
  puts "order#{i+1}:"
  puts "  status: '#{status.sample}'"
  puts "  customer_name: '#{Faker::Name.name}'"
  puts "  shipping_address: '#{Faker::Address.full_address}'"
  puts "  cardholder_name: '#{Faker::Name.name}'"
  puts "  cc_number: #{rand(1111111111111111..9999999999999999)}"
  puts "  cc_expiry: '#{(Date.today + 365).strftime('%m/%Y')}'"
  puts "  ccv: #{rand(100..999)}"
  puts "  billing_zip: #{rand(10000..99999)}"
end


# Users
10.times do |i|
  puts "user#{i+1}:"
  puts "  username: '#{Faker::Space.unique.galaxy.downcase.gsub(' ','-')}'"
  puts "  email: '#{Faker::Internet.email}'"
  puts "  uid: #{rand(1111111..9999999)}"
  puts "  provider: 'github'"
end


# Products
10.times do |i|
  puts "product#{i+1}:"
  puts "  name: '#{Faker::Movies::HitchhikersGuideToTheGalaxy.planet}'"
  puts "  price: #{rand(1000)}"
  puts "  photo_url: 'https://www.prettyprettypicture.com'"
  puts "  description: '#{Faker::Movies::HitchhikersGuideToTheGalaxy.quote}'"
  puts "  quantity: #{rand(1000)}"
  puts "  available: '#{[true, false].sample}'"
  puts "  user: user#{rand(1..10)}"
end


# Orderitems
10.times do |i|
  puts "orderitem#{i+1}:"
  puts "  quantity: #{rand(10)}"
  puts "  order: order#{rand(1..10)}"
  puts "  product: product#{rand(1..10)}"
end