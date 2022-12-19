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
			num_get += 1 if count == num_get + 1
			items = items.first(num_get)
		end
		return {items: items, count: count, overflow: (num_get ? num_get < count : false)}
	end

	def tooltip_title(date)
		datetime_end = self.datetime_end
		text = "#{self.title}\n"
		if self.is_all_day
			text += "終日"
		else
			text += "～ "
			if datetime_end.to_date == date
				text += datetime_end.strftime("%H:%M")
			else
				text += "終日"
			end
		end
		return text
	end

	def datetime_string
		define_variant
		string = @date_begin.strftime("%Y年%-m月%-d日(#{I18n.t("date.abbr_day_names")[@date_begin.wday]})")
		if is_all_day
			return string if @is_no_range
			string += " ～ #{@date_end.strftime("%Y年") if @is_span_years}#{@date_end.strftime("%-m月%-d日(#{I18n.t("date.abbr_day_names")[@date_end.wday]})")}"
		else
			string += @datetime_begin.strftime(" %H:%M")
			return string if @is_no_range
			string += " ～ #{@date_end.strftime("%Y年") if @is_span_years}#{@date_end.strftime("%-m月%-d日(#{I18n.t("date.abbr_day_names")[@date_end.wday]})") if @is_span_dates}#{@datetime_end.strftime(" %H:%M")}"
		end
		return string
	end

	private

	def define_variant
		@datetime_begin = self.datetime_begin
		@date_begin = @datetime_begin.to_date
		@datetime_end = self.datetime_end
		@date_end = @datetime_end.to_date
		@is_all_day = self.is_all_day
		@is_span_dates = @date_begin != @date_end
		@is_span_years = @date_begin.year != @date_end.year
		@is_no_range = @is_all_day ? !@is_span_dates : @datetime_begin == @datetime_end
	end
end
