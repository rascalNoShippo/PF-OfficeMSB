class UsersController < ApplicationController
	before_action :uniqueness, only: [:create, :update], if: -> {request.format == :js}

	def show
		@user = User.find(params[:id])
	end

	def edit
		@user = User.find(params[:id])
		@org = @user.user_organizations
		@preffered_org = @user.preferred_org.ids if @user.preferred_org_id
		raise Forbidden if current_user != @user && !current_user.is_admin
	end

	def update
		user = User.find(params[:id])
		if user.update(user_params)
			# ログイン名の変更は管理者のみ可能
			user.update(login_name: params[:user][:login_name]) if current_user.is_admin
			user.image.destroy if params[:user][:delete_image] == "true"

			if current_user.is_admin
				new_org_ids = params[:user][:organizations].split(";").map{|i| i.split(",").map{|j| j = j.to_i}}.map{|i| i.length == 1 ? i.push(nil) : i}
				org_ids = user.user_organizations.pluck(:organization_id, :position_id)

				# 新しい組織を追加
				(new_org_ids - org_ids).each do |ids|
					user.user_organizations.create(organization_id: ids[0], position_id: ids[1])
				end

				# 組織を削除
				(org_ids - new_org_ids).each do |ids|
					user.user_organizations.find_by(organization_id: ids[0], position_id: ids[1]).destroy
				end
			end

			# 優先する組織を変更
			if params[:user][:preferred_org_id]
				ids = params[:user][:preferred_org_id].split(",")
				preferred_org_id = user.user_organizations.find_by(organization_id: ids[0], position_id: ids[1]).id
				user.update(preferred_org_id: preferred_org_id)
			else
				user.update(preferred_org_id: nil)
			end

			flash[:notice] = "ユーザーデータを変更しました。"
			redirect_to user_path(user.id)
		end
	end

	def index
		users = User.all
		# 無効ユーザーは管理者のみ表示
		(users = users.where(is_invalid: nil)) unless current_user.is_admin
		@users = users.page(params[:page]).per(current_user.config.number_of_displayed_items)

		@q = params[:query]
		if @q
			q = @q.split
			user_ids = []
			User.includes(:user_organizations).each do |user|
				user_ids.push(user.id) if q.all?{|x| user.name_with_all_org.include?(x) || user.name_reading.include?(x)} && (!user.is_invalid || current_user.is_admin)
			end
			@users = @users.where(id: user_ids).or(@users.where(employee_number: q))
		end
	end

	def new
		@user = User.new
		raise Forbidden unless current_user.is_admin
	end

	def create
		user = User.new(user_params)
		if user.save
			UserConfig.create(user_id: user.id)

			#組織を追加
			new_org_ids = params[:user][:organizations].split(";").map{|i| i.split(",").map{|j| j = j.to_i}}
			new_org_ids.each do |ids|
				user.user_organizations.create(organization_id: ids[0], position_id: ids[1])
			end

			flash[:notice] = "ユーザーを追加しました。"
			redirect_to user_path(user.id)
		end
	end

	def uniqueness
		# ログイン名が重複しないよう制限
		user = User.find_by(login_name: params[:user][:login_name])
		#変更の場合は、現在のログイン名から変更がなければそのまま通す
		no_change = user == User.find(params[:id]) if params[:id]
		@exist = user && !no_change
		render "add_user"
	end

	def password_edit
		@user = User.find(params[:user_id])
		raise Forbidden if current_user != @user && !current_user.is_admin
	end

	def password_update
		user = User.find(params[:user_id])
		if p user.update_with_password(password_params)
			bypass_sign_in(user) if user == current_user
			flash[:notice] = "パスワードを変更しました。"
			redirect_to user_path(user.id)
		end
	end

	def invalidate
		user = User.find(params[:user_id])
		user.update(is_invalid: Time.zone.now)
		flash[:notice] = "“#{user[:name]}” のアカウントを無効にしました。"
		redirect_to user
	end

	def activate
		user = User.find(params[:user_id])
		user.update(is_invalid: nil)
		flash[:notice] = "“#{user[:name]}” のアカウントを有効にしました。"
		redirect_to user
	end

	def destroy
		user = User.find(params[:id])
		user_name = user[:name]
		if user.destroy
			flash[:notice] = "“#{user_name}” のアカウントと関連データを完全に削除しました。"
			redirect_to users_path
		end
	end

	private

	def password_params
		params.require(:user).permit(:password, :password_confirmation)
	end

	def user_params
		params.require(:user).permit(:name, :password, :is_admin, :employee_number, :email, :phone_number, :image)
	end
end
