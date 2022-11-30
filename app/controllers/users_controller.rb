class UsersController < ApplicationController
	before_action :uniqueness, only: [:create, :update], if: -> {request.format == :js}

	def show
		@user = User.find(params[:id])
	end

	def edit
		@user = User.find(params[:id])
		@header_hidden = true if @user_error = current_user != @user && !current_user.is_admin
	end

	def update
		user = User.find(params[:id])
		if user.update(user_params)
			# ログイン名の変更は管理者のみ可能
			user.update(login_name: params[:user][:login_name]) if current_user.is_admin
			user.image.destroy if params[:user][:delete_image] == "true"
			flash[:notice] = "ユーザーデータを変更しました。"
			redirect_to user_path(user.id)
		end
	end

	def index
		@users = User.all.page(params[:page]).per(current_user.config.number_of_displayed_items)
		@header_hidden = true if @user_error = !current_user.is_admin
	end


	def new
		@user = User.new
		@header_hidden = true if @user_error = !current_user.is_admin
	end

	def create
		user = User.new(user_params)
		if user.save
			UserConfig.create(user_id: user.id)
			flash[:notice] = "ユーザーを追加しました。"
			redirect_to user_path(user.id)
		end
	end

	def uniqueness
		# ログイン名が重複しないよう制限
		@exist = true if (user = User.find_by(login_name: params[:user][:login_name])) && user != User.find(params[:id])
		render "add_user"
	end

	def password_edit
		@user = User.find(params[:user_id])
		@header_hidden = true if @user_error = current_user != @user && !current_user.is_admin
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
		@current_user = current_user
		user = User.find(params[:user_id])
		user.update(is_invalid: Time.zone.now)
		sign_out(user)
		sign_in(@current_user)
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
