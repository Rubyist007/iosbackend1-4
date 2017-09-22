class Dish < ApplicationRecord
  belongs_to :restaurant
  has_and_belongs_to_many :evaluation

  validates_presence_of :name, :description, :photo#, ingredients
  
  validates :name, length: { maximum: 50 }

  validates :description, length: { minimum: 50, maximum: 300 }

  mount_base64_uploader :photo, DishUploader
end
