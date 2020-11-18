# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_upload_failures = []
20.times do |num|
  user = User.new

  user.username = "user#{num}"
  user.email = "#{Faker::Internet.email}"
  user.uid = "#{rand(1111111..9999999)}"
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
100.times do |num|
  product = Product.new

  product.name = "#{Faker::Movies::HitchhikersGuideToTheGalaxy.planet}"
  product.price = "#{rand(1000)}"
  product.photo_url = 'https://www.prettyprettypicture.com'
  product.description = "#{Faker::Movies::HitchhikersGuideToTheGalaxy.quote}"
  product.quantity = "#{rand(1000)}"
  product.available = "#{[true, false].sample}"
  product.user = "user#{rand(1..20)}"

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

# 10.times do |i|
#   puts "orderitem#{i+1}:"
#   puts "  quantity: #{rand(10)}"
#   puts "  order: order#{rand(1..10)}"
#   puts "  product: product#{rand(1..10)}"
# end

puts "done"