class CreateRatingRestaurants < ActiveRecord::Migration[5.1]
  def change
    create_table :rating_restaurants do |t|
      t.integer :count_evaluations, default: 0
      t.float   :sum_evaluations, default: 0
      t.float   :average_evaluations, default: 0
      t.timestamps
    end
  end
end
