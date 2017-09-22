# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do |n|
  User.create( 
    "nickname": "User-#{n}",
    "email": "test#{n}@gmail.com",
    "password": "123456789test",
    "latitude": "50.619808",
    "longitude": "26.249667",
    "avatar": open(Rails.root + "app/assets/images/testAvatar.png"),
    "confirmed_at": DateTime.now
  )
end

Admin.create( 
    "email": "admin@gmail.com",
    "password": "123456789test"
  )

5.times do |n|
  if n < 2
    Restaurant.create(
      "title": "Very good restaurant #{n}",
      "description": "Description good restaurant #{n}" * 7,
      "latitude": "50.619638",
      "longitude": "26.248218",
      "facade": open(Rails.root + "app/assets/images/restaurant-facade.jpg"),
      "logo": open(Rails.root + "app/assets/images/restaurant-logo.jpg")
    )
  else
    Restaurant.create(
      "title": "Very good restaurant #{n}",
      "description": "Description good restaurant #{n}" * 7, 
      "latitude": "50.631738",
      "longitude": "26.273297",
      "facade": open(Rails.root + "app/assets/images/restaurant-facade.jpg"),
      "logo": open(Rails.root + "app/assets/images/restaurant-logo.jpg")
    )
  end
end

Restaurant.all.each do |restaurant| 
  6.times.with_index do |i|
    restaurant.dishes.create("name": "Dish #{i}",
                             "description": "descripiton"*10,
                             "photo": open(Rails.root + "app/assets/images/Dish.jpg"))

  end
end

