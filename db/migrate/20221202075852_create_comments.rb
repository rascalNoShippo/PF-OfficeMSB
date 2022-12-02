class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :class_name, null: false
      t.integer :item_id, null: false
      t.integer :commenter_id, null: false
      t.text :body
      t.integer :comment_id, null: false
      t.timestamps
    end
  end
end
