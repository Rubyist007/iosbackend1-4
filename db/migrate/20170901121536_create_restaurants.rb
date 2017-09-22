class CreateRestaurants < ActiveRecord::Migration[5.1]
  def change
    create_table :restaurants do |t|
      t.string :title
      t.string :description
      t.string :facade
      t.string :logo
      t.integer :number_of_ratings, default: 0
      t.float :average_ratings, default: 0
      t.float :sum_ratings, default: 0
      t.float :actual_rating
      t.float :latitude
      t.float :longitude
      t.string :state
      t.string :city
      t.timestamps
    end
  end
end
