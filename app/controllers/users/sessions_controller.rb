# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  prepend_before_action :validation, only: [:create], if: -> {request.format == :js}
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    @header_hidden = true
    super
  end

  # POST /resource/sign_in
  def create
    super
    #ログイン日時を記録
      user = current_user
      last_login = user.current_sign_in_at
      user.update(current_sign_in_at: Time.zone.now, last_sign_in_at: last_login)
  end
  
  def validation
    # ログインIDが存在＆無効でない＆パスワードが合致 ⇒ オーソリ
    @authorized = (user = User.find_by(login_name: params[:user][:login_name])) && user.is_invalid.nil? && user.valid_password?(params[:user][:password])
    render "login_error_msg"
    # render 実行により create は実行せず終了
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
