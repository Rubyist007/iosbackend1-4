class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.string :subject
      t.string :text

      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
