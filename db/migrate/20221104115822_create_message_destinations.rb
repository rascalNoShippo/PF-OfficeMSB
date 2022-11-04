class CreateMessageDestinations < ActiveRecord::Migration[6.1]
  def change
    create_table :message_destinations do |t|
      t.integer :message_id, null: false
      t.integer :receiver_id, null: false
      t.boolean :is_editable, default: false
      t.integer :delete_flag, default: 0
      t.datetime :finished_reading
      t.datetime :last_viewing
      t.datetime :confirmed
      t.timestamps
    end
  end
end
