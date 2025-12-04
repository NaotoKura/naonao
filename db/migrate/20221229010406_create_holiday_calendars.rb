class CreateHolidayCalendars < ActiveRecord::Migration[7.0]
  def change
    create_table :holiday_calendars do |t|
      t.date :holiday_date

      t.timestamps
    end
  end
end
