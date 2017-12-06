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
       
      UpdateRestaurantDishUserAfterCreateEvaluationWorker.perform_async(evaluation_params[:evaluation], 
                                                                        dish.id, 
                                                                        dish.restaurant_id, 
                                                                        current_user.id)
       
      render json: { data: [evaluation] }
    rescue ActiveRecord::RecordNotUnique
      evaluation_id = Evaluation.where("user_id = #{current_user.id} and dish_id = #{dish.id}").ids
      update_from_user evaluation_id, evaluation_params[:evaluation]
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

  def update_from_user evaluation_id, new_evaluation
    e = Evaluation.find(evaluation_id)[0]
    old_evaluation = e.evaluation
    
    if current_user.id == e.user_id || current_user.admin == true
      e.update_attribute(:evaluation, new_evaluation)
    else
      return render json: { errors: ["You can't change this evaluation"] }
    end

    UpdateRestaurantDishUserAfterUpdateEvaluationWorker.perform_async(new_evaluation,
                                                                      old_evaluation,
                                                                      e.dish_id,
                                                                      e.restaurant_id, 
                                                                      current_user.id)

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

end
