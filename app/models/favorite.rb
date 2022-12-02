class Favorite < ApplicationRecord
	belongs_to :user

	def self.find?(item)
		Favorite.find_by(class_name: item.class.to_s, item_id: item.id, user_id: User.current_user.id)
	end

	def item
		self.class_name.constantize.find(self.item_id)
	end
end
