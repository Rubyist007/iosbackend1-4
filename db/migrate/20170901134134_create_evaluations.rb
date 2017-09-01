class CreateEvaluations < ActiveRecord::Migration[5.1]
  def change
    create_table :evaluations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :dish, index: true
      t.integer :evaluation
      t.timestamps
    end
  end
end
