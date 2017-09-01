class Dish < ApplicationRecord
  belongs_to :menu, index: true
  has_and_belongs_to_many :evaluation
end
