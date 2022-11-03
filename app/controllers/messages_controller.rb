class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end
  
  def new
    @user = current_user
    @message = @user.messages.new
  end

  def show
  end

  def edit
  end
end
