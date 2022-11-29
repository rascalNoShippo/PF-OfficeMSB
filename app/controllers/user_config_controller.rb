class UserConfigController < ApplicationController
	def edit
		@config = current_user.config
		@selector = [*1..10].map{|a| a*5}
	end
	
	def update
		config = current_user.config
		config.update(config_params)
		flash[:notice] = "設定を保存しました。"
		redirect_to current_user
	end
	
	private
	
	def config_params
		params.require(:user_config).permit(:number_of_displayed_items, :number_of_displayed_comments, :display_images_with_body)
	end
end
