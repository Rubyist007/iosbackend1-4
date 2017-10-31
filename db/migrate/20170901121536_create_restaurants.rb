class CreateRestaurants < ActiveRecord::Migration[5.1]
  def change
    create_table :restaurants do |t|
      t.string :title
      t.string :description
      t.string :photos, array: true
      t.integer :number_of_ratings, default: 0
      t.float :average_ratings, default: 0
      t.float :sum_ratings, default: 0
      t.float :actual_rating
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :street
      t.string :city
      t.string :state
      t.string :g_id
      t.integer :place_Contry
      t.integer :place_City

      t.timestamps
    end
  end
end
