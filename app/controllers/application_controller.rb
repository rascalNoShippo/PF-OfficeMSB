class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :authenticate_user!
	before_action :set_current_user
	
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:login_name, :email])
	end
	
  def set_current_user
    User.current_user = current_user
  end
  
  def date_or_time(time)
  	if time.at_beginning_of_day == Time.zone.now.at_beginning_of_day
  		time.strftime("%H:%M")
		elsif time.at_beginning_of_year == Time.zone.now.at_beginning_of_year
			time.strftime("%m月%d日(#{I18n.t("date.abbr_day_names")[time.wday]})")
		else
			time.strftime("%Y年%-m月%-d日(#{I18n.t("date.abbr_day_names")[time.wday]})")
		end
  end
  
  helper_method :plaintext
  helper_method :date_or_time
end
