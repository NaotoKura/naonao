class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.references :user, null: false, foreign_key: true # user_id（外部キー）
      t.datetime :start_time, null: false               # start_time（日時）
      t.datetime :end_time, null: false                 # end_time（日時）
      t.integer :category, null: false                   # category（整数型）
      t.string :content, null: false                   # content（内容）
      t.datetime :deadline                             # deadline（日時）
      t.integer :memo_id                               # memo_id（整数型）
      t.date :date                                     # date（年月日）

      t.timestamps
    end
  end
end
