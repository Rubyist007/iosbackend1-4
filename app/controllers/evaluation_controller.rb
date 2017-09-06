class EvaluationController < ApplicationController
    
    def index
      render json: Evaluation.all
    end

    def create 
      user = User.find(evaluation_params[:user_id])
      dish = Dish.find(evaluation_params[:dish_id])

      params = evaluation_params.merge ({ restaurant_id: dish.restaurant_id })

      evaluation = user.evaluation.create(params)
      dish.evaluation << evaluation

      user.rating_restaurant.create({restaurant_id: params[:restaurant_id],
                                     count_evaluations: 1,
                                     sum_evaluations: params[:evaluation],
                                     point: params[:evaluation]})

      update_rating_dish dish, evaluation_params[:evaluation]
      update_statistics_user user, evaluation_params[:evaluation]
      
      render json: evaluation
    end

    def show 
      #render json: Evaluation.find(params[:id])
      render json: Evaluation.where(user_id: params[:id])
    end

    def evaluation_user
      render json: Evaluation.where(user_id: params[:id])
    end

    private 

      def evaluation_params 
        params.require(:evaluation).permit(:user_id, :dish_id, :evaluation)
      end

      def update_rating_dish dish, evaluation
        return dish.update_attributes(:number_of_ratings => (dish.number_of_ratings + 1), 
                                      :sum_ratings => (dish.sum_ratings + evaluation), 
                                      :average_ratings => (dish.number_of_ratings != 0 ? dish.sum_ratings / dish.number_of_ratings : 0))
      end
      
      def update_statistics_user user, evaluation
        return user.update_attributes(:number_of_evaluations => (user.number_of_evaluations + 1), 
                                      :sum_ratings_of_evaluations => (user.sum_ratings_of_evaluations + evaluation), 
                                      :average_ratings_evaluations => (user.number_of_evaluations != 0 ? user.sum_ratings_of_evaluations / user.number_of_evaluations : 0))
      end

end
