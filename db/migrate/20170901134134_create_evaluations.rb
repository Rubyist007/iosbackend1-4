class CreateEvaluations < ActiveRecord::Migration[5.1]
  def change
    create_table :evaluations do |t|
      t.integer :user_id
      t.integer :dish_id
      t.float :evaluation
      t.timestamps
    end
  end
end
