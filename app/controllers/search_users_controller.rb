class SearchUsersController < ApplicationController
	
  def search_users
    q = params[:message][:query].split
    
    user_ids = []
    User.includes(:user_organizations).each do |user|
      user_ids.push(user.id) if q.all?{|x| user.name_with_all_org.include?(x)} && !user.is_invalid
    end
    
    @user_list = (q.length == 0 ? User.all : User.find(user_ids))
    render "messages/search_user"
  end
end
