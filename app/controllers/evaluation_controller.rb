class EvaluationController < ApplicationController

  before_action :authenticate!, expect: [:update, :destroy]
  before_action :current_user_admin? , only: [:update, :destroy]
  before_action :not_ban_user, only: [:create]
    
  def my
    render json: { data: current_user.my_evaluations }
  end

  def create

    begin
      dish = Dish.find(evaluation_params[:dish_id])
      params = evaluation_params.merge ({ restaurant_id: dish.restaurant_id, user_id: current_user.id })
      evaluation = current_user.evaluation.create(params)
      dish.evaluation << evaluation
      
      update_rating_dish dish, evaluation_params[:evaluation]
      update_rating_restaurant dish.restaurant_id, evaluation_params[:evaluation]
      update_statistics_user current_user, evaluation_params[:evaluation]
      
      render json: {data: [evaluation]}
    rescue ActiveRecord::RecordNotUnique
      evaluation_id = Evaluation.where("user_id = #{current_user.id} and dish_id = #{dish.id}").ids
      update_from_user evaluation_id, evaluation_params[:evaluation]
      #redirect_to action: ":update, id: evaluation_id#, evaluation: {dish_id: dish.id, evaluation: [arams}
    end

  end

  def user
    render json: { data: Evaluation.user_evaluations(User.find(params[:id])) }
  end

  def show
    render json: { data: Evaluation.where(user_id: params[:id]) }
  end

  def update
    evaluation = Evaluation.find(params[:id])
    evaluation.update_attributes(evaluation: evaluation_params[:evaluation],
                                 photo: evaluation_params[:photo])

    render json: { data: [evaluation] }
  end

  def update_from_user id, evaluation
    e = Evaluation.find(id)[0]
    p e 
    if current_user.id == e.user_id || current_user.admin == true
      e.update_attribute(:evaluation, evaluation)
    else
      return render json: { errors: ["You can't change this evaluation"] }
    end

    dish = Dish.find(e.dish_id)

    update_rating_dish dish, evaluation
    update_rating_restaurant dish.restaurant_id, evaluation
    update_statistics_user current_user, evaluation

    render json: { data: [e] }
  end

  def evaluation_user
    render json: Evaluation.where(user_id: params[:id])
  end

  def destroy
    evaluation = Evaluation.find(params[:id])
    evaluation.destroy
    render json: { data: [{ status: "Record destroyed" }] }, status: 200

    rescue ActiveRecord::RecordNotFound
      render json: { status: 404, errors: ["Couldn't find Evaluation with 'id'=#{params[:id]}"] }, status: 404
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
      top_hundred = Restaurant.all.where("number_of_ratings >= ?", 50).order(actual_rating: :desc).limit(100)
      top_city = Restaurant.all.where("number_of_ratings >= :limitation 
                                       AND state = :state
                                       AND (:city IS NULL OR city = :city)",
                                      limitation: 50, 
                                      state: restaurant.state,
                                      city: restaurant.city).
                  order(actual_rating: :desc).limit(10)

                  
      top_hundred_place = top_hundred.index(restaurant)
      top_city_place = top_city.index(restaurant)

      restaurant.update_attributes(:number_of_ratings => (restaurant.number_of_ratings + 1),
                                   :sum_ratings => (restaurant.sum_ratings + evaluation), 
                                   :average_ratings => (restaurant.number_of_ratings != 0 ? 
                                                        restaurant.sum_ratings / restaurant.number_of_ratings : 
                                                        evaluation),
                                   :actual_rating => ((((restaurant.number_of_ratings + 1).to_f / ((restaurant.number_of_ratings + 1) + 50)) * (restaurant.number_of_ratings != 0 ? restaurant.sum_ratings / restaurant.number_of_ratings : evaluation)) + ((50.0 / ((restaurant.number_of_ratings + 1) + 50) * 3.5 ))),
                                   :place_Country => ((top_hundred_place + 1) if top_hundred_place.is_a? Numeric),
                                   :place_City => ((top_city_place + 1) if top_city_place.is_a? Numeric))

    end
      
    def update_statistics_user user, evaluation
      return user.update_attributes(:number_of_evaluations => (user.number_of_evaluations + 1), 
                                    :sum_ratings_of_evaluations => (user.sum_ratings_of_evaluations + evaluation), 
                                    :average_ratings_evaluations => (user.number_of_evaluations != 0 ? 
                                                                     (user.sum_ratings_of_evaluations / user.number_of_evaluations).to_f : 
                                                                     evaluation))
    end
end
