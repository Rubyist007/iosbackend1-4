# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do |n|
  User.create( 
    "email": "test#{n}@gmail.com",
    "password": "123456789test" 
  )
end

5.times do |n|
  Restaurant.create(
    "title": "Very good restaurant #{n}",
    "description": "Description good restaurant #{n}" * 7 
  )
end

Restaurant.all.each.with_index do |restaurant, n| 
  restaurant.dishes.create("name": "Dish #{n}")
end
