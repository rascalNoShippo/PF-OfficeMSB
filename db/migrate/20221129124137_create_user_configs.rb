class CreateUserConfigs < ActiveRecord::Migration[6.1]
  def change
    create_table :user_configs do |t|
      t.integer :user_id, null: false
      t.integer :number_of_displayed_items, default: 10
      t.integer :number_of_displayed_comments, default: 10
      t.boolean :display_images_with_body, default: true
      t.timestamps
    end
  end
end
