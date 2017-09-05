class CreateRestaurants < ActiveRecord::Migration[5.1]
  def change
    create_table :restaurants do |t|
      t.string :title
      t.string :description
      t.string :main_photo
      t.timestamps
    end
  end
end
