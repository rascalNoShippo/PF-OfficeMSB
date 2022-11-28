class BulletinBoard < ApplicationRecord
	belongs_to :sender, class_name: "User"
	has_many :comments, class_name: "BulletinBoardComment", dependent: :destroy
	has_many :view_flags, class_name: "BulletinBoardViewFlag", dependent: :destroy
	belongs_to :last_update_user, class_name: "User", optional: true
	has_many_attached :attachments

	def already_read_flag
		self.view_flags.find_by(user_id: User.current_user.id)
	end

end
