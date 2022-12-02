class Comment < ApplicationRecord
	belongs_to :commenter, class_name: "User"
	has_many_attached :attachments

	def item
		self.class_name.constantize.find(self.item_id)
	end

end
