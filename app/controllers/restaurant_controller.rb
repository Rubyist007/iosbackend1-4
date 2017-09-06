class RestaurantController < ApplicationController

  def index
    render json: Restaurant.all.first(10)
  end

  def create
    restaurant = Restaurant.new(restaurant_params)
    restaurant.save
    render json: restaurant
  end

  def show 
    render json: Restaurant.find(params[:id])
  end

  private

    def restaurant_params
      params.require(:restaurant).permit(:title , :description)
    end
end
