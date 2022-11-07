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
      #送信者は自動的に受信者にもなる
      message.message_destinations.create(receiver_id: current_user.id) unless destination_ids.include?(current_user.id)
      redirect_to message_path(message.id)
    end

  end

  def show
    @message = Message.find(params[:id])
    @receivers = @message.receivers.where(id: @message.message_destinations.pluck(:receiver_id))
    @editors = @receivers.where(id: @message.message_destinations.where(is_editable: true).pluck(:receiver_id))
    
    #宛先に含まれているか、送信者でないと表示されない
    unless @message.sender == current_user || @receivers.include?(current_user)
      @message_error = true
      @header_hidden = true
      return
    end
    
    #宛先に含まれていれば既読をマークする
    if @receivers.include?(current_user)
      last_view = @message.already_read_flag
      @message.mark_already_read
    end
    
    @new_comment = @message.comments.new
    @comments = @message.comments.order(created_at: :DESC)
    
    #未表示のコメントがハイライトされる仕様
    @viewed_comment = @message.receiver_model.viewed_comment
    @message.receiver_model.update(viewed_comment: @message.number_of_comments)
    @unread_after_update = last_view < @message.update_content_at unless last_view.nil? || @message.update_content_at.nil?
    
    #宛先リストに表示される上限数
    @limit_view_receivers = 10
  end

  def edit
    @message = Message.find(params[:id])
    @user_list = User.all #要変更
    @receivers = @message.receivers.where(id: @message.message_destinations.pluck(:receiver_id))
    @editors = @receivers.where(id: @message.message_destinations.where(is_editable: true).pluck(:receiver_id))
    
    #編集者か、送信者でないと表示されない
    unless @message.sender == current_user || @editors.include?(current_user)
      @message_error = true
      @header_hidden = true
      return
    end
  end

  def update
    message = Message.find(params[:id])
    
    if message.update(message_params)
      new_destination_ids = params[:message][:destination]
      new_destination_ids.shift
      new_destination_ids.map!{|n| n.to_i}
      
      #新しい宛先が指定されたら追加する
      destination_ids = message.message_destinations.pluck(:receiver_id)
      (new_destination_ids - destination_ids).each do |receiver_id|
        message.message_destinations.create(receiver_id: receiver_id)
      end
      
      #既存の宛先が無ければ削除する（送信者自身は削除されない）
      (destination_ids - new_destination_ids).each do |receiver_id|
        message.message_destinations.find_by(receiver_id: receiver_id).destroy unless receiver_id == message.user_id
      end
      
      redirect_to message_path(message.id)
    end
  end

  private

	def message_params
		params.require(:message).permit(:title, :body, :attachments, :is_commentable, :confirmation_flag)
	end

end
