require 'rails_helper'

RSpec.describe Dish, type: :model do
  
  before do 
    restaurant = Restaurant.new( title: 'Test restaurant',
                                 description: 'restaurant description' * 10,
                                 main_photo: nil )
    restaurant.create_menu

    @dish = restaurant.menu.dishes.create( 
                      name: 'Test dish',
                      description: 'restaurant description' * 10,
                      photo: nil,
                      ingredients: ['ing1', 'ing2'],
                      number_of_ratings: 0,
                      average_ratings: 0,
                      sum_ratings: 0
                                         )
  end

  subject { @dish }

  it { should respond_to :name }
  it { should respond_to :description }
  it { should respond_to :photo }
  it { should respond_to :ingredients }
  it { should respond_to :number_of_ratings }
  it { should respond_to :average_ratings }
  it { should respond_to :sum_ratings }
 
  it { should be_valid }

  describe "Dish whose have name bigger than 50 symbols" do 
    before { @dish.name = 'a' * 51 }
    it { should_not be_valid }
  end

  describe "Dish whose have description less than 50 symbols" do 
    before { @dish.description = 'a' * 49 }
    it { should_not be_valid }
  end
    
  describe "Dish whose have description bigger than 500 symbols" do 
    before { @dish.description = 'a' * 501 }
    it { should_not be_valid }
  end

end
