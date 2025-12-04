class AddMultipleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :code, :string
    add_column :users, :age, :integer
    add_column :users, :year, :integer
    add_column :users, :month, :integer
    add_column :users, :gender, :integer
  end
end
