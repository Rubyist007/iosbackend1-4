class EvaluationController < ApplicationController

  #before_action :authenticate_user!
    
  def index
    render json: Evaluation.all
  end

  def create        
    dish = Dish.find(evaluation_params[:dish_id])

    params = evaluation_params.merge ({ restaurant_id: dish.restaurant_id, user_id: current_user.id })

    evaluation = current_user.evaluation.create(params)
    
    dish.evaluation << evaluation

    update_rating_dish dish, evaluation_params[:evaluation]
    update_rating_restaurant dish.restaurant_id, evaluation_params[:evaluation]
    update_statistics_user current_user, evaluation_params[:evaluation]
      
    render json: {Data: evaluation}
  end

  def show
    render json: {Data: Evaluation.where(user_id: params[:id])}
  end

  def update
    e = Evaluation.find(params[:id])
    if current_user.id == e.user_id
      e.update_attribute(:evaluation, evaluation_params[:evaluation])
    end

    dish = Dish.find(evaluation_params[:id])

    update_rating_dish dish, evaluation_params[:evaluation]
    update_rating_restaurant dish.restaurant_id, evaluation_params[:evaluation]
    update_statistics_user current_user, evaluation_params[:evaluation]
  end

  def evaluation_user
    render json: Evaluation.where(user_id: params[:id])
  end

  private 

    def evaluation_params 
      params.require(:evaluation).permit(:dish_id, :evaluation, :photo)
    end

    def update_rating_dish dish, evaluation
             dish.update_attributes(:number_of_ratings => (dish.number_of_ratings + 1), 
                                    :sum_ratings => (dish.sum_ratings + evaluation), 
                                    :average_ratings => (dish.number_of_ratings != 0 ? 
                                                         dish.sum_ratings / dish.number_of_ratings : 
                                                         evaluation),
                                   :actual_rating => ((((dish.number_of_ratings + 1).to_f / ((dish.number_of_ratings + 1) + 50)) * (dish.number_of_ratings != 0 ? dish.sum_ratings / dish.number_of_ratings : evaluation)) + ((50.0 / ((dish.number_of_ratings + 1) + 50) * 3.5 ))))
    end

    def update_rating_restaurant restaurant_id, evaluation
      restaurant = Restaurant.find(restaurant_id)
      restaurant.update_attributes(:number_of_ratings => (restaurant.number_of_ratings + 1),
                                   :sum_ratings => (restaurant.sum_ratings + evaluation), 
                                   :average_ratings => (restaurant.number_of_ratings != 0 ? 
                                                        restaurant.sum_ratings / restaurant.number_of_ratings : 
                                                        evaluation),
                                   :actual_rating => ((((restaurant.number_of_ratings + 1).to_f / ((restaurant.number_of_ratings + 1) + 50)) * (restaurant.number_of_ratings != 0 ? restaurant.sum_ratings / restaurant.number_of_ratings : evaluation)) + ((50.0 / ((restaurant.number_of_ratings + 1) + 50) * 3.5 ))))

    end
      
    def update_statistics_user user, evaluation
      return user.update_attributes(:number_of_evaluations => (user.number_of_evaluations + 1), 
                                    :sum_ratings_of_evaluations => (user.sum_ratings_of_evaluations + evaluation), 
                                    :average_ratings_evaluations => (user.number_of_evaluations != 0 ? 
                                                                     user.sum_ratings_of_evaluations / user.number_of_evaluations : 
                                                                     evaluation))
    end
end
