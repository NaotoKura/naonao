class CreateMemos < ActiveRecord::Migration[7.0]
  def change
    create_table :memos do |t|
      t.references :schedule, null: false, foreign_key: true # schedule_id（外部キー）
      t.text :memo                 # memo（テキスト）

      t.timestamps
    end
  end
end
