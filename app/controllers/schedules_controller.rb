class SchedulesController < ApplicationController
	helper_method :date
	helper_method :wday
	helper_method :day_classes

	def index
		@user = User.find(params[:user_id])
		@schedules = @user.schedules
		@today = Time.zone.today
		@month = @today.at_beginning_of_month.months_since(params[:month].to_i)
		@end_week = week_num(@month)
	end

	def new
		@schedule = current_user.schedules.new
		@date = params[:date] ? params[:date].to_date : Time.zone.today
	end

	def create
		user = current_user
		schedule = user.schedules.new(schedule_params)
		schedule.datetime_begin = "#{params[:schedule][:date_begin]} #{params[:schedule][:time_begin]} JST".to_time
		schedule.datetime_end = "#{params[:schedule][:date_end]} #{params[:schedule][:time_end]} JST".to_time
		schedule.user_name = user.name
		if schedule.is_all_day
			schedule.datetime_begin = schedule.datetime_begin.at_beginning_of_day
			schedule.datetime_end = schedule.datetime_end.at_end_of_day
		end
		if schedule.save
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
		raise Forbidden unless schedule.user == current_user
		schedule.datetime_begin = "#{params[:schedule][:date_begin]} #{params[:schedule][:time_begin]} JST".to_time
		schedule.datetime_end = "#{params[:schedule][:date_end]} #{params[:schedule][:time_end]} JST".to_time
		if schedule.is_all_day
			schedule.datetime_begin = schedule.datetime_begin.at_beginning_of_day
			schedule.datetime_end = schedule.datetime_end.at_end_of_day
		end
		if schedule.update(schedule_params)
			schedule.delete_attachments(params[:schedule][:existing_files])
			flash[:notice] = "予定を変更しました。"
			redirect_to schedule
		end
	end

	def destroy
		schedule = Schedule.find(params[:id])
		raise Forbidden unless schedule.user == current_user
		title = schedule.title
		schedule.destroy
		flash[:notice] = "予定 “#{title}” を削除しました。"
		redirect_to user_schedules_path(current_user)
	end



	# ヘルパーメソッド ここから
		def date(i, j)
			start_day_week = @month.wday - current_user.config.start_weeks
			start_day_week += 7 if start_day_week < 0
			start_day = @month.day - start_day_week
			day_num = start_day + i * 7 + j
			return @month.days_since(day_num - 1)
		end

		def wday(i)
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

	def week_num(month)
		# カレンダーの行数を設定
			i = 0
			while date(i, 0) <= month.at_end_of_month do
				i += 1
			end
			return i - 1
	end
	# ヘルパーメソッド ここまで

	def calendar
		# 月移動
		index
		@months_since = params[:month]
		render "calendar"
	end

	def schedules
		# 件数多い際に別窓で表示
		index
		@date = params[:date].to_date
		@schedules = @schedules.each_day(@date)[:items]
		render "schedule_modal"
	end

	private

	def schedule_params
		params.require(:schedule).permit(:title, :body, :is_all_day, :place, :is_commentable, attachments: [])
	end
end
