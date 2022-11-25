class CreateBulletinBoardComments < ActiveRecord::Migration[6.1]
  def change
    create_table :bulletin_board_comments do |t|
      t.integer :bulletin_board_id, null: false
      t.integer :commenter_id, null: false
      t.text :body
      t.integer :comment_id, null: false
      t.timestamps
    end
  end
end
