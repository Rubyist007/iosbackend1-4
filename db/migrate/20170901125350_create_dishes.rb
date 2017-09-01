class CreateDishes < ActiveRecord::Migration[5.1]
  def change
    create_table :dishes do |t|
      t.belongs_to :menu, index: true
      t.string :name
      t.string :description
      t.string :photo
      t.string :ingredients
      t.integer :number_of_ratings
      t.integer :average_rating
      t.integer :sum_rating
      t.timestamps
    end
  end
end
