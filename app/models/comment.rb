class Comment < ApplicationRecord
	belongs_to :commenter, class_name: "User"
	belongs_to :user, class_name: "User", foreign_key: "commenter_id"
	has_many_attached :attachments

	def item
		self.class_name.constantize.find(self.item_id)
	end

end
