class MessageComment < ApplicationRecord
	belongs_to :commenter, class_name: "User"
	belongs_to :message
	has_many_attached :attachments

end
