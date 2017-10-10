class RestaurantController < ApplicationController

 #before_action :current_user_admin?, only: [:create, :update]
 #before_action :authenticate_user!, expect: [:create, :update]

  def index
    render json: Restaurant.all.first(10)
  end

  def create
    restaurant = Restaurant.new(restaurant_params)
    if restaurant.save
      render json: restaurant
    else
      render json: {status: 422, error: restaurant.errors.full_messages}, status: 422
    end
  end

  def show 
    render json: Restaurant.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {status: 404, error: "Couldn't find Restaurant with 'id'=#{params[:id]}"}, status: 404
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
    render json: {status: 422, error: "You must provide state"} if params[:state] == nil
    render json: Restaurant.all.where("number_of_ratings >= :limitation 
                                      AND state = :state
                                      AND (:city IS NULL OR city = :city)",
                                      limitation: 50, 
                                      state: params[:state],
                                      city: params[:"city/district"] || nil).
    order(actual_rating: :desc).limit(10)
  end

  def near
    render json: {status: 422, error: "You must provide distance"} if params[:distance] == nil
    render json: Restaurant.near([current_user.latitude, 
                                  current_user.longitude], 
                                  params[:distance])
  end

  private

    def restaurant_params
      params.require(:restaurant).permit(:title , :description, :facade, :logo, :latitude, :longitude)
    end
end
