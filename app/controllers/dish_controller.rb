class DishController < ApplicationController
  
  before_action :current_user_admin?, only: [:create, :update]
  before_action :authenticate_any!, expect: [:create, :update]

  def create
    dish = Restaurant.find(params[:restaurant_id]).dishes.create(dish_params)
    if dish.save
      render json: dish
    else
      render json: {status: 422, error: dish.errors.full_messages}, status: 422
    end
  rescue ActiveRecord::RecordNotFound
    render json: {status: 404, error: "Couldn't find Dish with 'id'=#{params[:restaurant_id]}"}, status: 404
  end

  def index
    render json: Restaurant.find(params[:restaurant_id]).dishes
  rescue ActiveRecord::RecordNotFound
    render json: {status: 404, error: "Couldn't find Restaurant with 'id'=#{params[:restaurant_id]}"}, status: 404
  end
  
  def show
    render json: Dish.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {status: 404, error: "Couldn't find Dish with 'id'=#{params[:id]}"}, status: 404
  end

  def update
    Dish.find(params[:id]).update_attributes(dish_params)
  end

  private

    def dish_params
      params.require(:dish).permit(:name , :description, :latitude, :longitude, :photo)
    end
end

