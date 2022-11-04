class MessagesController < ApplicationController
  def index
    @messages = current_user.received_messages.order(updated_at: :DESC)
  end

  def new
    user = current_user
    @message = user.messages.new
    @user_list = User.all #要変更
  end

  def create
    message = current_user.messages.new(message_params)
    if message.save
    destination_ids = params[:message][:destination]
      destination_ids.shift
      destination_ids.each do |receiver_id|
        message.message_destinations.create(receiver_id: receiver_id)
      end
      redirect_to message_path(message.id)
    end

  end

  def show
    @message = Message.find(params[:id])
    @receivers = @message.receivers
    return unless @message.sender == current_user || @receivers.include?(current_user) #宛先に含まれているか、送信者でないと表示されない
    @message.mark_already_read if @receivers.include?(current_user) #宛先に含まれていれば既読とマークする
    @new_comment = @message.comments.new
    @comments = @message.comments.order(created_at: :DESC)
    @limit_view_receivers = 10
  end

  def edit
  end

  private

	def message_params
		params.require(:message).permit(:title, :body, :attachments, :is_commentable, :confirmation_flag)
	end

end
