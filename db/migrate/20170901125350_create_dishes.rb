class CreateDishes < ActiveRecord::Migration[5.1]
  def change
    create_table :dishes do |t|
      t.belongs_to :restaurant, index: true
      t.string :name
      t.string :description
      t.string :photo
      #t.string :ingredients
      t.integer :number_of_ratings, default: 0
      t.float :average_ratings, default: 0
      t.float :sum_ratings, default: 0
      t.float :actual_rating 
      t.integer :restaurant_id
      t.timestamps
    end

    create_table :dishes_evaluations, id:false do |t|
      t.belongs_to :evaluation, index: true
      t.belongs_to :dish, index: true
    end
  end
end
