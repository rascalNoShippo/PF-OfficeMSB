class SearchUsersController < ApplicationController
	
  def search_users
    queries = params[:message][:query].split.map{|x| x = "%#{x}%"}
    @user_list = queries.length == 0 ? User.all : User.where("name like ?", queries)
    render "messages/search_user"
  end
end
