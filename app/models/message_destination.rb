class MessageDestination < ApplicationRecord
	belongs_to :receiver, class_name: "User"
	belongs_to :message
end
