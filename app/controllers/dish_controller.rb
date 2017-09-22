class DishController < ApplicationController
  
  #before_action :authenticate_admin!, only: [:create]
  #before_action :authenticate_any!, expect: [:create]

  def create
    dish = Restaurant.find(params[:restaurant_id]).dishes.create(dish_params)
    dish.save
    render json: dish
  end

  def index
    render json: Restaurant.find(params[:restaurant_id]).dishes
  end
  
  def show
    render json: Dish.find(params[:id])
  end

  def update
    Dish.find(params[:id]).update_attributes(dish_params)
  end

  private

    def dish_params
      params.require(:dish).permit(:name , :description, :latitude, :longitude, :photo)
    end
end

