class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.integer :user_id, null: false
      t.string :user_name, null: false
      t.string :title, null: false
      t.text :body
      t.string :place
      t.datetime :datetime_begin, null: false
      t.datetime :datetime_end, null: false
      t.boolean :is_all_day, default: false
      t.boolean :is_commentable, default: true
      t.integer :number_of_comments, default: 0
      t.datetime :update_content_at
      t.integer :last_update_user_id
      t.timestamps
    end
  end
end
