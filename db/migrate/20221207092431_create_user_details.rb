class CreateUserDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :user_details do |t|
      t.integer :user_id
      t.string :url
      t.text :profile

      t.timestamps
    end
  end
end
