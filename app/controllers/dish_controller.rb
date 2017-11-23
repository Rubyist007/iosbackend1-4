class DishController < ApplicationController
  
  before_action :current_user_admin?, only: [:create, :update]
  before_action :authenticate_user!, expect: [:create, :update]

  def create
    dish = Restaurant.find(params[:restaurant_id]).dishes.create(dish_params)
    if dish.save
      render json: { data: [dish] }
    else
      render json: { status: 422, errors: dish.errors.full_messages }, status: 422
    end
  rescue ActiveRecord::RecordNotFound
    render json: { status: 404, errors: "Couldn't find Dish with 'id'=#{params[:restaurant_id]}" }, status: 404
  end

  def index
    render json: { data: Restaurant.find(params[:restaurant_id]).dishes }
  rescue ActiveRecord::RecordNotFound
    render json: { status: 404, errors: "Couldn't find Restaurant with 'id'=#{params[:restaurant_id]}" }, status: 404
  end
  
  def show
    render json: { data: [Dish.find(params[:id])] }
  rescue ActiveRecord::RecordNotFound
    render json: { status: 404, errors: "Couldn't find Dish with 'id'=#{params[:id]}" }, status: 404
  end

  def update
    dish = Dish.find(params[:id]).update_attributes(dish_params)
    if dish.save
      render json: { data: [dish] }
    else
      render json: { status: 422, errors: dish.errors.full_messages }, status: 422
    end
  end

  private

    def dish_params
      params.require(:dish).permit(:name , :description, :photo, :type_dish, :price)
    end
end

