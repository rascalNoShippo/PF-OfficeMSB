class Message < ApplicationRecord
	belongs_to :sender, class_name: "User", foreign_key: "user_id"
	belongs_to :last_update_user, class_name: "User", foreign_key: "last_update_user_id", optional: true
	has_many :message_destinations, dependent: :destroy
	has_many :receivers, through: :message_destinations
	has_many :comments, -> { where(class_name: "Message") }, foreign_key: "item_id", dependent: :destroy
	has_many :favorites, -> { where(class_name: "Message") }, foreign_key: "item_id" , dependent: :destroy
	has_many_attached :attachments

	def receiver_model
		self.message_destinations.find_by(receiver_id: User.current_user.id)
	end

	def already_read_flag
		self.receiver_model.finished_reading
	end

	def editors
		editor_ids = self.message_destinations.where(is_editable: true).pluck(:receiver_id)
		self.receivers.where(id: editor_ids)
	end

	def recycled?
		self.message_destinations.find_by(receiver_id: User.current_user).delete_flag == 1
	end

end
