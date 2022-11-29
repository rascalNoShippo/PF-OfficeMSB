class UsersController < ApplicationController
	before_action :validation, only: [:create], if: -> {request.format == :js}
	
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
			user.image.destroy if params[:user][:delete_image] == "true"
			flash[:notice] = "変更しました。"
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
	
	def validation
		# ログイン名が重複しないよう制限
		@exist = true if User.find_by(login_name: params[:user][:login_name])
		render "add_user"
	end

	def password_edit
		@user = User.find(params[:user_id])
		@header_hidden = true if @user_error = current_user != @user && !current_user.is_admin
	end

	def password_update
		user = current_user
		if p user.update_with_password(password_params)
			bypass_sign_in(user)
			flash[:notice] = "パスワードを変更しました。"
			redirect_to user_path(user.id)
		end
	end


	private

	def password_params
		params.require(:user).permit(:password, :password_confirmation)
	end

	def user_params
		params.require(:user).permit(:name, :login_name, :password, :is_admin, :employee_number, :email, :phone_number, :image)
	end
end
