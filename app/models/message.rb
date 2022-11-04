class Message < ApplicationRecord
	belongs_to :sender, class_name: "User", foreign_key: "user_id"
	belongs_to :last_update_user, class_name: "User", foreign_key: "last_update_user_id", optional: true
	has_many :message_destinations, dependent: :destroy
	has_many :receivers, through: :message_destinations
	has_many :comments, class_name: "MessageComment", dependent: :destroy
	has_many_attached :attachments
	#has_rich_text :body
	
	def receiver_model
		message_destinations.find_by(receiver_id: User.current_user.id)
	end
	
	def already_read_flag
		self.receiver_model.finished_reading
	end
	
	def mark_already_read
		unless self.already_read_flag
			self.receiver_model.update(finished_reading: Time.zone.now)
		end
	end
end
