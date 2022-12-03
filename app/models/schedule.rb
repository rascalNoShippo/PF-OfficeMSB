class Schedule < ApplicationRecord
	has_many_attached :attachments
	
	belongs_to :user
	has_many :comments, -> { where(class_name: "Schedule") }, foreign_key: "item_id", dependent: :destroy
	has_many :favorites, -> { where(class_name: "Schedule") }, foreign_key: "item_id" , dependent: :destroy
	belongs_to :last_update_user, class_name: "User", foreign_key: "last_update_user_id", optional: true

	def self.each_day(date, num_get = nil)
		# 指定日の予定一覧 第2引数で最大件数を指定
		items = self.where(datetime_begin: ..(date.at_end_of_day), datetime_end: (date.at_beginning_of_day)..)
		items = items.order(is_all_day: :DESC).order(:datetime_begin).order(datetime_end: :DESC)
		count = items.count
		if num_get
			num_get = count == num_get + 1 ? num_get + 1 : num_get
			items = items.first(num_get)
		end
		return {items: items, count: count, overflow: (num_get ? num_get < count : false)}
	end

end
