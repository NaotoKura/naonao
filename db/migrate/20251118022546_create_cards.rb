class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :title
      t.integer :priority
      t.date :due_date
      t.integer :position
      t.references :lane, foreign_key: true

      t.timestamps
    end
  end
end
