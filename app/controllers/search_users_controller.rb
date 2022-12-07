class SearchUsersController < ApplicationController
	
  def search_users
    queries = params[:message][:query].split
    
    user_ids = []
    User.all.each do |user|
      user_ids.push(user.id) if queries.any?{|x| user.name.include?(x)} && !user.is_invalid
    end
    
    @user_list = (queries.length == 0 ? User.all : User.find(user_ids))
    render "messages/search_user"
  end
end
