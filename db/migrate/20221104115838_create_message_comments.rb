class CreateMessageComments < ActiveRecord::Migration[6.1]
  def change
    create_table :message_comments do |t|
      t.integer :message_id, null: false
      t.integer :commenter_id, null: false
      t.integer :comment_id, null: false
      t.text :body
      t.timestamps
    end
  end
end
