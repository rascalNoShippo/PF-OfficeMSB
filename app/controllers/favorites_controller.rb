class FavoritesController < ApplicationController

	def create
		@item = params[:class_name].constantize.find(params[:item_id])
		user = current_user
		Favorite.create(class_name: params[:class_name], item_id: params[:item_id], user_id: user.id)
		render "favorites/star"
	end

	def destroy
		favorite = Favorite.find(params[:id])
		@item = favorite.item
		favorite.destroy
		render "favorites/star"
	end

	def index
		@favorites = Favorite.where(user_id: current_user.id).order(created_at: :DESC).page(params[:page]).per(current_user.config.number_of_displayed_items)
	end

end
