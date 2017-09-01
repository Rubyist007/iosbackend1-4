class Dish < ApplicationRecord
  belongs_to :menu, index: true
end
