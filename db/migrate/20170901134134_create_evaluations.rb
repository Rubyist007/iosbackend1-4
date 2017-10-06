class CreateEvaluations < ActiveRecord::Migration[5.1]
  def change
    create_table :evaluations do |t|
      t.integer :user_id
      t.integer :dish_id
      t.integer :restaurant_id
      t.float :evaluation
      #t.string :comment
      t.timestamps
    end

    add_index :evaluations, [:user_id, :dish_id], unique: true
  end
end
