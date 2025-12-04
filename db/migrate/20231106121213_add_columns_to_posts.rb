class AddColumnsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :work_content, :text
    add_column :posts, :study_content, :text
    add_column :posts, :notices_content, :text
  end
end
