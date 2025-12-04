class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
