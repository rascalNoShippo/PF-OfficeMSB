class SearchUsersController < ApplicationController

  def search_users
    queries = params[:message][:query]
    @user_list = User.search(queries)
    render "messages/search_user"
  end
end
