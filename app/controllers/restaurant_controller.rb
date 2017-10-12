class RestaurantController < ApplicationController

 #before_action :current_user_admin?, only: [:create, :update]
 #before_action :authenticate_user!, expect: [:create, :update]

  def index
    render json: {data: Restaurant.all.first(10)}
  end

  def create
    restaurant = Restaurant.new(restaurant_params)
    if restaurant.save
      render json: {data: restaurant}
    else
      render json: {status: 422, errors: restaurant.errors.full_messages}, status: 422
    end
  end

  def show 
    render json: {data: Restaurant.find(params[:id])}
  rescue ActiveRecord::RecordNotFound
    render json: {status: 404, errors: "Couldn't find Restaurant with 'id'=#{params[:id]}"}, status: 404
  end

  def update
    r = Restaurant.find(params[:id])
    r.update_attributes(restaurant_params)
    render json: {data: r}
  end

  def top_hundred
    render json: { data: Restaurant.all.where("number_of_ratings >= ?", 50).order(actual_rating: :desc).limit(100) }
  end

  def top_ten_in_city
    return render json: {status: 422, errors: "You must provide state"} if request.headers["state"] == nil
    return render json: {status: 422, errors: "You must provide city"} if request.headers["city"] == nil

    render json: {data: Restaurant.all.where("number_of_ratings >= :limitation 
                                              AND state = :state
                                              AND (:city IS NULL OR city = :city)",
                                              limitation: 50, 
                                              state: request.headers["state"],
                                              city: request.headers["city"]).
                  order(actual_rating: :desc).limit(10)}
  end

  def near
    return render json: {status: 422, errors: "You must provide distance"} if request.headers["distance"] == nil
    render json: {data: Restaurant.near([current_user.latitude, 
                                         current_user.longitude], 
                                         request.headers["distance"])}
  end

  private

    def restaurant_params
      params.require(:restaurant).permit(:title , :description, :latitude, :longitude, :number_of_ratings, :actual_rating, :g_id, photos: [])
    end
end
