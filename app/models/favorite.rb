class Favorite < ApplicationRecord
	belongs_to :user

	def item
		self.class_name.constantize.find(self.item_id)
	end
end
