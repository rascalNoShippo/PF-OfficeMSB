class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.text :body
      t.string :place
      t.datetime :datetime_begin, null: false
      t.datetime :datetime_end, null: false
      t.boolean :is_all_day, default: false
      t.boolean :is_commentable, default: true
      t.timestamps
    end
  end
end
