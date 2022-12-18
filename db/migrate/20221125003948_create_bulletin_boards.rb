class CreateBulletinBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :bulletin_boards do |t|
      t.integer :user_id, null: false
      t.string :user_name, null: false
      t.integer :last_update_user_id
      t.string :title, null: false
      t.text :body
      t.boolean :is_commentable, default: true
      t.integer :number_of_comments, default: 0
      t.datetime :update_content_at
      t.timestamps
    end
  end
end
