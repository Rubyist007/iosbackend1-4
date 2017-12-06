class RestaurantController < ApplicationController

  before_action :authenticate_user!
  before_action :current_user_admin!, only: [:create, :update]

  def index
    render json: { data: Restaurant.all }
  end

  def create
    restaurant = Restaurant.new(restaurant_params)
    if restaurant.save
      render json: { data: [restaurant] }
    else
      render_errors_422(restaurant.errors.full_messages)
    end
  end

  def show 
    render json: { data: [Restaurant.find(params[:id])] }
  rescue ActiveRecord::RecordNotFound
    not_find_by_id("Restaurant", params[:id])
  end

  def update
    restaurant = Restaurant.find(params[:id])
    
    if restaurant.update_attributes(restaurant_params)
      render json: { data: [restaurant] }
    else
      render_errors_422(restaurant.errors.full_messages)
    end 
  rescue ActiveRecord::RecordNotFound
    not_find_by_id("Restaurant", params[:id])
  end

  def all_city
    all_city = []

    Restaurant.distinct.pluck(:city, :state).each do |locality|
      all_city <<  { city: locality[0], state: locality[1] }
    end

    render json: { data: all_city }
  end

  def all_restaurant_in_city
    unless provided_state_and_city!
      render json: { data: Restaurant.where(city: request.headers["city"], state: request.headers["state"]) }
    end
  end

  def top_hundred
    render json: { data: Restaurant.where("number_of_ratings >= ?", 50).order(actual_rating: :desc).limit(100) }
  end

  def top_ten_in_city
    unless provided_state_and_city!
      render json: { data: Restaurant.where("number_of_ratings >= :limitation 
                                             AND state = :state
                                             AND (:city IS NULL OR city = :city)",
                                             limitation: 50, 
                                             state: request.headers["state"],
                                             city: request.headers["city"]).
                     order(actual_rating: :desc).limit(10) }
    end
  end

  def near
    return render json: {status: 422, errors: "You must provide distance"} if request.headers["distance"] == nil

    render json: { data: Restaurant.near([current_user.latitude, 
                                         current_user.longitude], 
                                         request.headers["distance"]) }
  end

  private

    def restaurant_params
      params.require(:restaurant).permit(:title , :description, :latitude, :longitude, :number_of_ratings, :actual_rating, :g_id, photos: [])
    end

    def provided_state_and_city!
      return render json: {status: 422, errors: "You must provide state"} if request.headers["state"] == nil
      return render json: {status: 422, errors: "You must provide city"} if request.headers["city"] == nil
    end
end
