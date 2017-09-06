class DishController < ApplicationController
  
  def create
    dish = Restaurant.find(params[:id]).dishes.create(dish_params)
    dish.save
    render json: dish
  end

  def index
    render json: Dish.all
  end
  
  def show
    render json: Restaurant.find(params[:id_restaurant]).menu.dishes.find(params[:id_dishes])
  end

  private

    def dish_params
      params.require(:dish).permit(:name , :description)
    end
end

