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
		@favorites = Favorite.where(user_id: current_user.id).order(created_at: :DESC).page(params[:page]).per(10)

    #paginationカウンター
    @total_count = @favorites.total_count
    @per_page = @favorites.limit_value
    @current_page = @favorites.current_page
    @num_pages = @favorites.total_pages
    @count_start = (@current_page - 1) * @per_page + 1
    @count_end = @favorites.last_page? ? @total_count : @current_page * @per_page

	end

end
