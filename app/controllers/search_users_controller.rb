class SearchUsersController < ApplicationController

  def search_users
    q = params[:message][:query].split.map{|x| x = "%#{x}%"}
    column = []
    q.count.times{|a| column.push("(name like ? or name_with_all_org like ? or name_reading like ?)")}
    column = column.join(" and ")
    q = (q * 3).sort

    @user_list = (q.length == 0 ? User.all : User.where(column, *(q)))
    render "messages/search_user"
  end
end
