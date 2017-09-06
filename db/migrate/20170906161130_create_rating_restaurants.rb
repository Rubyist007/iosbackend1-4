class CreateRatingRestaurants < ActiveRecord::Migration[5.1]
  def change
    create_table :rating_restaurants do |t|
      t.belongs_to :user
      t.integer :restaurant_id
      t.integer :count_evaluations
      t.float   :sum_evaluations
      t.float   :point
      t.timestamps
    end
  end
end
