class SearchUsersController < ApplicationController

  def search_users
    @user_list = User.search(params[:message][:query])
    render "messages/search_user"
  end
end
