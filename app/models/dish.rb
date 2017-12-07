class Dish < ApplicationRecord
  belongs_to :restaurant
  has_many :evaluation

  validates_presence_of :name, :description, :type_dish, :price#, ingredients
  
  validates :name, length: { maximum: 50 }

  validates :description, length: { minimum: 10, maximum: 300 }

  mount_base64_uploader :photo, DishUploader
end
