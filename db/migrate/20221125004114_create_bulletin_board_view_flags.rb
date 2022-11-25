class CreateBulletinBoardViewFlags < ActiveRecord::Migration[6.1]
  def change
    create_table :bulletin_board_view_flags do |t|
      t.integer :bulletin_board_id, null: false
      t.integer :user_id, null: false
      t.integer :viewed_comment, default: 0
      t.timestamps
    end
  end
end
