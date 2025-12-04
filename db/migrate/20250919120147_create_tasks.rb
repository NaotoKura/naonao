class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :status
      t.integer :priority
      t.date :start_date
      t.date :due_date
      t.references :user, foreign_key: true
      t.references :creator, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
