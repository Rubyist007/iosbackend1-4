require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  
  before do 
    @restaurant = Restaurant.new( title: 'Test restaurant',
                                  description: 'restaurant description' * 10,
                                  main_photo: nil )
  end

  subject { @restaurant }

  it { should respond_to :title }
  it { should respond_to :description }
  it { should respond_to :main_photo }

  it { should be_valid }

  describe "Restaurant whose have title bigger than 50 symbols" do 
    before { @restaurant.title = 'a' * 51 }
    it { should_not be_valid }
  end

  describe "Restaurant whose have description less than 100 symbols" do 
    before { @restaurant.description = 'a' * 99 }
    it { should_not be_valid }
  end
    
  describe "Restaurant whose have description bigger than 500 symbols" do 
    before { @restaurant.description = 'a' * 501 }
    it { should_not be_valid }
  end

end
