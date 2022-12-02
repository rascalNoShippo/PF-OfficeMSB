class SchedulesController < ApplicationController
	helper_method :day
	helper_method :week

	def index
		@q = params[:query]
		@today = Time.zone.today
		@month = @today.at_beginning_of_month.months_since(params[:month].to_i)
		@end_week = day(5, 0).month == @month.month ? 5 : 4
	end

	def day(i, j)
		start_day_week = @month.wday - current_user.config.start_weeks
		start_day_week += 7 if start_day_week < 0
		start_day = @month.day - start_day_week
		day_num = start_day + i * 7 + j
		return @month.days_since(day_num - 1)
	end

	def week(i)
		(i + current_user.config.start_weeks) % 7
	end

	def calendar
		index
		p @months_since = params[:month]
		render "calendar"
	end

end
