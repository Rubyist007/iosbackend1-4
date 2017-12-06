class DishController < ApplicationController
   
  before_action :authenticate_user!
  before_action :current_user_admin!, only: [:create, :update]

  def create
    dish = Restaurant.find(params[:restaurant_id]).dishes.create(dish_params)
    if dish.save
      render json: { data: [dish] }
    else
      render_errors_422(dish.errors.full_messages)
    end
  rescue ActiveRecord::RecordNotFound
    not_find_by_id("Restaurant", params[:restaurant_id])
  end

  def index
    render json: { data: Restaurant.find(params[:restaurant_id]).dishes }
  rescue ActiveRecord::RecordNotFound
    not_find_by_id("Restaurant", params[:restaurant_id])
  end
  
  def show
    render json: { data: [Dish.find(params[:id])] }
  rescue ActiveRecord::RecordNotFound
    not_find_by_id("Dish", params[:id])
  end

  def update
    dish = Dish.find(params[:id])

    if dish.update_attributes(dish_params)
      render json: { data: [dish] }
    else
      render_errors_422(dish.errors.full_messages)
    end
  rescue ActiveRecord::RecordNotFound
    not_find_by_id("Dish", params[:id])
  end

  private

    def dish_params
      params.require(:dish).permit(:name , :description, :photo, :type_dish, :price)
    end
end

