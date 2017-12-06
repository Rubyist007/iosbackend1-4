class UpdateRestaurantDishUserAfterCreateEvaluationWorker
  include Sidekiq::Worker

  def perform(evaluation, dish_id, restaurant_id, user_id)
    update_rating_dish dish_id, evaluation
    update_rating_restaurant restaurant_id, evaluation
    update_statistics_user user_id, evaluation
  end


  def update_rating_dish dish_id, evaluation
      dish = Dish.find(dish_id)
      number_of_ratings = dish.number_of_ratings + 1
      sum_ratings = dish.sum_ratings + evaluation

      dish.update_attributes(:number_of_ratings => (number_of_ratings),
                             :sum_ratings => (sum_ratings),
                             :average_ratings => (sum_ratings / number_of_ratings).to_f,
                             :actual_rating => (calculation_actual_rating(number_of_ratings, sum_ratings)))
  end

  def update_rating_restaurant restaurant_id, evaluation
    restaurant = Restaurant.find(restaurant_id)
    top_hundred = Restaurant.all.where("number_of_ratings >= ?", 50).order(actual_rating: :desc).limit(100)
    top_city = Restaurant.all.where("number_of_ratings >= :limitation 
                                     AND state = :state
                                     AND (:city IS NULL OR city = :city)",
                                     limitation: 50, 
                                     state: restaurant.state,
                                     city: restaurant.city).
                order(actual_rating: :desc).limit(10)
                 
    top_hundred_place = top_hundred.index(restaurant) + 1
    top_city_place = top_city.index(restaurant) + 1
    number_of_ratings = restaurant.number_of_ratings + 1
    sum_ratings = restaurant.sum_ratings + evaluation


    restaurant.update_attributes(:number_of_ratings => (number_of_ratings),
                                 :sum_ratings => (sum_ratings), 
                                 :average_ratings => ((restaurant.sum_ratings / restaurant.number_of_ratings).to_f),
                                 :actual_rating => (calculation_actual_rating(number_of_ratings, sum_ratings)),
                                 :place_Country => ((top_hundred_place) if top_hundred_place.is_a? Numeric),
                                 :place_City => ((top_city_place) if top_city_place.is_a? Numeric))
  end
      
  def update_statistics_user user_id, evaluation
    user = User.find(user_id)
    number_of_evaluations = user.number_of_evaluations + 1
    sum_ratings_of_evaluations = user.sum_ratings_of_evaluations + evaluation
    
    return user.update_attributes(:number_of_evaluations => (number_of_evaluations), 
                                  :sum_ratings_of_evaluations => (sum_ratings_of_evaluations), 
                                  :average_ratings_evaluations => (((sum_ratings_of_evaluations) / (number_of_evaluations)).to_f))
  end

  def calculation_actual_rating number_of_ratings, sum_ratings
    (((number_of_ratings.to_f / (number_of_ratings + 50)) * (sum_ratings / number_of_ratings).to_f) + 
    (((50.0 / (number_of_ratings + 50)) * 3.5)))
  end
end
