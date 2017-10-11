class RestaurantController < ApplicationController

 #before_action :current_user_admin?, only: [:create, :update]
 #before_action :authenticate_user!, expect: [:create, :update]

  def index
    render json: {Data: Restaurant.all.first(10)}
  end

  def create
    restaurant = Restaurant.new(restaurant_params)
    if restaurant.save
      render json: {Data: restaurant}
    else
      render json: {status: 422, errors: restaurant.errors.full_messages}, status: 422
    end
  end

  def show 
    render json: {Data: Restaurant.find(params[:id])}
  rescue ActiveRecord::RecordNotFound
    render json: {status: 404, errors: "Couldn't find Restaurant with 'id'=#{params[:id]}"}, status: 404
  end

  def update
    r = Restaurant.find(params[:id])
    r.update_attributes(restaurant_params)
    render json: {Data: r}
  end

  def top_hundred
    render json: { Data: Restaurant.all.where("number_of_ratings >= ?", 50).order(actual_rating: :desc).limit(100) }
  end

  def top_ten_in_city
    render json: {status: 422, errors: "You must provide state"} if params[:state] == nil
    render json: {status: 422, errors: "You must provide city"} if params[:city] == nil

    render json: {Data: Restaurant.all.where("number_of_ratings >= :limitation 
                                      AND state = :state
                                      AND (:city IS NULL OR city = :city)",
                                      limitation: 50, 
                                      state: params[:state],
                                      city: params[:"city/district"] || nil).
    order(actual_rating: :desc).limit(10)}
  end

  def near
    render json: {status: 422, errors: "You must provide distance"} if params[:distance] == nil
    render json: {Data: Restaurant.near([current_user.latitude, 
                                  current_user.longitude], 
                                  params[:distance])}
  end

  private

    def restaurant_params
      params.require(:restaurant).permit(:title , :description, :latitude, :longitude, :g_id, photos: [])
    end
end
