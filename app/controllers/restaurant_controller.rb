class RestaurantController < ApplicationController

  #before_action :authenticate_admin!, only: [:create]
  #before_action :authenticate_any!, expect: [:create]

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

  def update
    r = Restaurant.find(params[:id])
    r.update_attributes(restaurant_params)
    render json: r
  end


  def top_hundred
    render json: Restaurant.all.where("number_of_ratings >= ?", 50).order(actual_rating: :desc).limit(100)
  end

  def top_ten_in_region
    raise "Dont have state" if params[:state] == nil
    render json: Restaurant.all.where("number_of_ratings >= :limitation 
                                      AND state = :state
                                      AND (:city IS NULL OR city = :city)",
                                      limitation: 50, 
                                      state: params[:state],
                                      city: params[:city] || nil).
    order(actual_rating: :desc).limit(10)
  end


  def near
    raise "Dont have distance" if params[:distance] == nil
    render json: Restaurant.near([current_user.latitude, 
                                  current_user.longitude], 
                                  params[:distance])
  end

  private

    def restaurant_params
      params.require(:restaurant).permit(:title , :description, :facade, :logo, :latitude, :longitude)
    end
end
