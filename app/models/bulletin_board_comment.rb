class BulletinBoardComment < ApplicationRecord
	belongs_to :commenter, class_name: "User"
	belongs_to :bulletin_board
	has_many_attached :attachments
end
