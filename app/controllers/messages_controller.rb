class MessagesController < ApplicationController
  def index
    @user = current_user
    @box = @user.messages_list(params[:box])
    @messages = @box[:messages]
    @q = params[:query]
    @messages = @messages.search!(@q).includes(:favorites, :user).page(params[:page]).per(@user.config.number_of_displayed_items)
  end

  def new
    user = current_user
    @message = user.messages.new
    @user_list = User.where(is_invalid: nil)
  end

  def create
    user = current_user
    message = user.messages.new(message_params)
    if message.save
      message.destination_create(params[:message][:destination], params[:message][:editor])
      flash[:notice] = "メッセージを作成しました。"
      redirect_to message
    end

  end

  def show
    @message = Message.find(params[:id])
    @user = current_user
    @receivers = @message.receivers
    #宛先に含まれているか、送信者でないと表示されない
      return raise Forbidden unless @message.user == @user || @receivers.include?(@user)
    @editors = @message.editors
    @new_comment = @message.comments.new
    @comments = @message.comments.order(created_at: :DESC).page(params[:page]).per(@user.config.number_of_displayed_comments)
    @viewed_comment = @message.receiver_model.viewed_comment
    @unread_after_update = @message.set_already_read

    #宛先リストに表示される上限数
      @limit_view_receivers = 10
  end

  def edit
    @message = Message.find(params[:id])
    @user_list = User.where(is_invalid: nil)
    @receivers = @message.receivers.where(id: @message.message_destinations.pluck(:receiver_id))
    @editors = @receivers.where(id: @message.message_destinations.where(is_editable: true).pluck(:receiver_id))

    #編集者か、送信者でないと表示されない
      raise Forbidden unless @message.user == current_user || @editors.include?(current_user)
  end

  def update
    message = Message.find(params[:id])
    message_updated_date = message.updated_at
    if message.update(message_params)
      #内容が更新されていれば最終更新をマーク
        if message.updated_at > message_updated_date
          message.update(update_content_at: message.updated_at, last_update_user_id: current_user.id)
        end
      message.destination_update(params[:message][:destination], params[:message][:editor])
      message.delete_attachments(params[:message][:existing_files])

      flash[:notice] = "メッセージを変更しました。"
      redirect_to message
    end
  end

  def destroy
    message = Message.find(params[:id])
    flash[:notice] = "“#{message.title}”は完全に削除されました。"
    message.destroy
    redirect_to messages_path
  end

  def receivers
    @message = Message.find(params[:id])
    @destinations = @message.message_destinations.includes(:receiver)
    raise Forbidden unless @message.receivers.include?(current_user)
  end

  def trash
    message = Message.find(params[:id])
    message.message_destinations.find_by(receiver_id: current_user.id).update(delete_flag: 1)
    flash[:notice] = "“#{message.title}”をごみ箱に移動しました。"
    redirect_to messages_path(box: "trash")
  end

  def restore
    message = Message.find(params[:id])
    message.message_destinations.find_by(receiver_id: current_user.id).update(delete_flag: 0)
    flash[:notice] = "“#{message.title}”を受信箱に戻しました。"
    redirect_to message_path
  end

  private

	def message_params
		params.require(:message).permit(:title, :body, :is_commentable, :confirmation_flag, attachments: [])
	end

end
