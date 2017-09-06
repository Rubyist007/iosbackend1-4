class Restaurant < ApplicationRecord
  has_many :dishes

  validates_presence_of :title, :description#, :main_photo

  validates :title, length: { maximum: 50 }

  validates :description, length: { minimum: 100, maximum: 500 }
end
