class Menu < ApplicationRecord
  belongs_to :restaurant
  has_meny :dishes
end
