class SchedulesController < ApplicationController
	helper_method :day
	helper_method :week
	helper_method :day_classes

	def index
		@user = User.find(params[:user_id])
		@schedules = @user.schedules
		@q = params[:query]
		@today = Time.zone.today
		@month = @today.at_beginning_of_month.months_since(params[:month].to_i)

		i = 0
		while day(i, 0) <= @month.at_end_of_month do
			i += 1
		end
		@end_week = i - 1
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

	def day_classes(date)
		day_class = []
		if HolidayJapan.check(date)
			day_class.push("holiday")
		elsif date.wday == 0
			day_class.push("sunday")
		elsif date.wday == 6
			day_class.push("saturday")
		end
		unless date.month == @month.month
			day_class.push("no_included")
		end
		if date == @today
			day_class.push("today")
		end
		return " " + day_class.join(" ")
	end

	def calendar
		index
		@months_since = params[:month]
		render "calendar"
	end

	def schedules
		index
		@date = params[:date].to_date
		@schedules = @schedules.each_day(@date)[:items]
		render "schedule_modal"
	end

	def new
		@schedule = current_user.schedules.new
		@date = params[:date] ? params[:date].to_date : Time.zone.today
	end

	def create
		schedule = current_user.schedules.new(schedule_params)
		schedule.datetime_begin = "#{params[:schedule][:date_begin]} #{params[:schedule][:time_begin]} JST".to_time
		schedule.datetime_end = "#{params[:schedule][:date_end]} #{params[:schedule][:time_end]} JST".to_time
		if schedule.is_all_day
			schedule.datetime_begin = schedule.datetime_begin.at_beginning_of_day
			schedule.datetime_end = schedule.datetime_end.at_end_of_day
		end
		if p schedule.save
			flash[:notice] = "予定を作成しました。"
			redirect_to schedule
		end
	end

	def show
		@schedule = Schedule.find(params[:id])
		@comments = @schedule.comments.order(created_at: :DESC).page(params[:page]).per(current_user.config.number_of_displayed_comments)
		@new_comment = @comments.new(commenter_id: current_user.id)
		@viewed_comment = 1.0 / 0
	end

	def edit
		@schedule = Schedule.find(params[:id])
		raise Forbidden unless @schedule.user == current_user
	end

	def update
		schedule = Schedule.find(params[:id])
		schedule.datetime_begin = "#{params[:schedule][:date_begin]} #{params[:schedule][:time_begin]} JST".to_time
		schedule.datetime_end = "#{params[:schedule][:date_end]} #{params[:schedule][:time_end]} JST".to_time
		if schedule.is_all_day
			schedule.datetime_begin = schedule.datetime_begin.at_beginning_of_day
			schedule.datetime_end = schedule.datetime_end.at_end_of_day
		end
		if schedule.update(schedule_params)
			#添付ファイルの削除
			remove_file_ids = params[:schedule][:existing_files]
			unless remove_file_ids.nil?
				remove_file_ids.each do |file_id|
					schedule.attachments.find(file_id).purge
				end
			end
			flash[:notice] = "予定を変更しました。"
			redirect_to schedule
		end
	end

	def destroy
		schedule = Schedule.find(params[:id])
		title = schedule.title
		schedule.destroy
		flash[:notice] = "予定 “#{title}” を削除しました。"
		redirect_to user_schedules_path(current_user)
	end

	private

	def schedule_params
		params.require(:schedule).permit(:title, :body, :is_all_day, :place, :is_commentable, attachments: [])
	end
end
