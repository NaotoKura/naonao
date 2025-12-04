class CreateLanes < ActiveRecord::Migration[7.0]
  def change
    create_table :lanes do |t|
      t.string :name
      t.integer :position
      t.references :board, foreign_key: true

      t.timestamps
    end
  end
end
