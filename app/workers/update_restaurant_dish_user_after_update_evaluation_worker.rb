class UpdateRestaurantDishUserAfterUpdateEvaluationWorker
  include Sidekiq::Worker

  sidekiq_options queue: :update_after_update_evaluation 

  def perform(new_evaluation, old_evaluation, dish_id, restaurant_id, user_id)
    update_rating_dish dish_id, new_evaluation, old_evaluation
    update_rating_restaurant restaurant_id, new_evaluation, old_evaluation
    update_statistics_user user_id, new_evaluation, old_evaluation
  end

  def update_rating_dish dish_id, new_evaluation, old_evaluation
      dish = Dish.find(dish_id)
      number_of_ratings = dish.number_of_ratings
      sum_ratings = dish.sum_ratings - old_evaluation + new_evaluation


      dish.update_attributes(:sum_ratings => (sum_ratings),
                             :average_ratings => (sum_ratings / number_of_ratings).to_f,
                             :actual_rating => (calculation_actual_rating(number_of_ratings, sum_ratings)))
  end

  def update_rating_restaurant restaurant_id, new_evaluation, old_evaluation
    restaurant = Restaurant.find(restaurant_id)
    top_hundred = Restaurant.all.where("number_of_ratings >= ?", 50).order(actual_rating: :desc).limit(100)
    top_city = Restaurant.all.where("number_of_ratings >= :limitation 
                                     AND state = :state
                                     AND (:city IS NULL OR city = :city)",
                                     limitation: 50, 
                                     state: restaurant.state,
                                     city: restaurant.city).
                order(actual_rating: :desc).limit(10)
                  
    begin            
      top_hundred_place = top_hundred.index(restaurant) + 1
      top_city_place = top_city.index(restaurant) + 1
    rescue NoMethodError
      top_hundred_place = nil
      top_city_place = nil
    end
    
    number_of_ratings = restaurant.number_of_ratings
    sum_ratings = restaurant.sum_ratings - old_evaluation + new_evaluation

    restaurant.update_attributes(:sum_ratings => (sum_ratings), 
                                 :average_ratings => ((restaurant.sum_ratings / restaurant.number_of_ratings).to_f),
                                 :actual_rating => (calculation_actual_rating(number_of_ratings, sum_ratings)),
                                 :place_Country => ((top_hundred_place) if top_hundred_place.is_a? Numeric),
                                 :place_City => ((top_city_place) if top_city_place.is_a? Numeric))
  end
      
  def update_statistics_user user_id, new_evaluation, old_evaluation
    user = User.find(user_id)
    number_of_evaluations = user.number_of_evaluations
    sum_ratings_of_evaluations = user.sum_ratings_of_evaluations - old_evaluation + new_evaluation
    
    return user.update_attributes(:sum_ratings_of_evaluations => (sum_ratings_of_evaluations), 
                                  :average_ratings_evaluations => (((sum_ratings_of_evaluations) / (number_of_evaluations)).to_f))
  end

  def calculation_actual_rating number_of_ratings, sum_ratings
    (((number_of_ratings.to_f / (number_of_ratings + 50)) * (sum_ratings / number_of_ratings).to_f) + 
    (((50.0 / (number_of_ratings + 50)) * 3.5)))
  end
end
