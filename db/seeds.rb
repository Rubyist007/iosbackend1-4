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
    "first_name": "name_user#{n}",
    "last_name": "sname_user#{n}",
    "password": "123456789test",
    "latitude": "50.619808",
    "longitude": "26.249667",
    "avatar": open(Rails.root + "app/assets/images/testAvatar.png"),
    "confirmed_at": DateTime.now
  )
end


User.create( 
    "email": "admin@gmail.com",
    "password": "123456789test",
    "first_name": "admin_user",
    "last_name": "admin_user",
    "latitude": "50.619808",
    "longitude": "26.249667",
    "avatar": open(Rails.root + "app/assets/images/testAvatar.png"),
    "confirmed_at": DateTime.now,
    "admin": true
  )

5.times do |n|
  if n < 2
    Restaurant.create(
      "title": "Restaurant #{n}",
      "description": "Description restaurant #{n}" * 7,
      "latitude": "41.318641",
      "longitude": "-72.933905",
      "photos": [open(Rails.root + "app/assets/images/restaurant-facade.jpg")],
      "number_of_ratings": "60",
      "sum_ratings": "300",
      "average_ratings": "5",
      "actual_rating": "4.62"
    )
  else
    Restaurant.create(
      "title": "Restaurant #{n}",
      "description": "Description restaurant #{n}" * 7, 
      "latitude": "50.631738",
      "longitude": "26.273297",
      )
  end
end

Restaurant.all.each do |restaurant| 
  6.times.with_index do |i|
    dish = restaurant.dishes.create("name": "Dish #{i}",
                             "description": "descripiton"*13,
                             "photo": open(Rails.root + "app/assets/images/Dish.jpg"),
                             "type_dish": "pizza",
                             "price": 20)
    evaluation = dish.evaluation.create(
          "user_id": 1,
          "restaurant_id": restaurant.id,
          "evaluation": 5,
          "photo": open(Rails.root + "app/assets/images/Dish.jpg"),
          "dish_id": (i + ( 6 * restaurant.id - 6) + 1)
        )

    User.first.evaluation << evaluation
  end
end

#120.times do |n|
  #if n < 50
    #2.times do |u|
    #  user = u+1
    #  5.times do |d|
    #    dish = d+1
    #    Evaluation.create(
    #      "user_id": user,
    #      "restaurant_id": 1,
    #      "evaluation": 5,
    #      "dish_id": dish
    #    )
    #  end
    #end
 # else
    #3.times do |u|
    #  user = u+3
    #  5.times do |d|
    #    dish = d+1
    #    Evaluation.create(
    #      "user_id": user,
    #      "restaurant_id": 2,
    #      "evaluation": 4,
    #      "dish_id": dish
    #    )
    #  end
    #end
  #end
#end
