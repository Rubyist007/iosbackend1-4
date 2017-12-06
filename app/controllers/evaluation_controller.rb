class EvaluationController < ApplicationController

  before_action :authenticate_user!
  before_action :current_user_admin! , only: [:update, :destroy]
  before_action :not_banned_user!, only: [:create]
    
  def my
    render json: { data: current_user.my_evaluations }
  end

  def create
    dish = Dish.find(evaluation_params[:dish_id])
    params = evaluation_params.merge({ restaurant_id: dish.restaurant_id, user_id: current_user.id })
    evaluation = current_user.evaluation.create(params)
    
    if evaluation.save
      dish.evaluation << evaluation
    else
      return render_errors_422(evaluation.errors.full_messages)
    end 
       
    UpdateRestaurantDishUserAfterCreateEvaluationWorker.perform_async(evaluation_params[:evaluation], 
                                                                      dish.id, 
                                                                      dish.restaurant_id, 
                                                                      current_user.id)
    
    render json: { data: [evaluation] }
  rescue ActiveRecord::RecordNotUnique
    evaluation = Evaluation.where("user_id = #{current_user.id} and dish_id = #{dish.id}")[0]
    user_update_existing_evaluation(evaluation, evaluation_params[:evaluation], evaluation_params[:photo])
  end

  def user
    render json: { data: Evaluation.user_evaluations(User.find(params[:id])) }
  rescue ActiveRecord::RecordNotFound
    not_find_by_id("User", params[:id])
  end

  def update
    evaluation = Evaluation.find(params[:id])
    if evaluation.update_attributes(evaluation: evaluation_params[:evaluation],
                                    photo: evaluation_params[:photo])
      render json: { data: [evaluation] }
    else
      render_errors_422(evaluation.errors.full_messages)
    end
  rescue ActiveRecord::RecordNotFound
    not_find_by_id("Evaluation", params[:id])
  end

  def user_update_existing_evaluation(obj_evaluation, new_evaluation, new_photo="")
    old_evaluation = obj_evaluation.evaluation
    
    if current_user.id == obj_evaluation.user_id || current_user.admin == true
      obj_evaluation.update_attributes(evaluation: new_evaluation,
                                       photo: new_photo)
    else
      return render json: { status: 403, errors: ["You can't change this evaluation"] }, status: 403
    end

    UpdateRestaurantDishUserAfterUpdateEvaluationWorker.perform_async(new_evaluation,
                                                                      old_evaluation,
                                                                      obj_evaluation.dish_id,
                                                                      obj_evaluation.restaurant_id, 
                                                                      current_user.id)

    render json: { data: [obj_evaluation] }
  end

  def destroy
    evaluation = Evaluation.find(params[:id])
    if evaluation.destroy
      render json: { data: [{ status: "Record destroyed" }] }, status: 200
    else
      render_errors_422(evaluation.errors.full_messages)
    end
  rescue ActiveRecord::RecordNotFound
    not_find_by_id("Evaluation", params[:id])
  end

  private 

    def evaluation_params 
      params.require(:evaluation).permit(:dish_id, :evaluation, :photo)
    end
end
