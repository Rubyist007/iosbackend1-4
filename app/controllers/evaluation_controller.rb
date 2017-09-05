class EvaluationController < ApplicationController
    
    def index
      render json: Evaluation.all
    end

    def create 
      #evaluation = Evaluation.new(evaluation_params)
      evaluation = User.find(evaluation_params[:user_id]).evaluation.create(evaluation_params)

      #User.find(evaluation_params[:user_id]).evaluation << evaluation
      dish = Dish.find(evaluation_params[:dish_id])
      dish.evaluation << evaluation
      update_rating dish, evaluation_params[:evaluation]

      render json: evaluation
    end

    def show 
      render json: Evaluation.find(params[:id])
    end

    def evaluation_user
      render json: Evaluation.where(user_id: params[:id])
    end

    private 

      def evaluation_params 
        params.require(:evaluation).permit(:user_id, :dish_id, :evaluation)
      end

      def update_rating dish, evaluation
        return dish.update_attributes(:number_of_ratings => (dish.number_of_ratings + 1), :sum_ratings => (dish.sum_ratings + evaluation), :average_ratings => (dish.sum_ratings / dish.number_of_ratings))


        #dish.update_attribute(:number_of_ratings, (dish.number_of_ratings + 1))
        #dish.update_attribute(:sum_ratings, (dish.sum_ratings + evaluation))
        #dish.update_attribute(:average_ratings, (dish.sum_ratings / dish.number_of_ratings))
      end
end
