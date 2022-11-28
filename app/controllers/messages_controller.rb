class MessagesController < ApplicationController
  def index
    #レコード取得
    messages = current_user.received_messages.order(updated_at: :DESC)
    ids = current_user.message_destinations.where(delete_flag: 0).pluck(:message_id)
    if @is_send_box = params[:box] == "send"
      messages = current_user.messages.where(id: ids).order(updated_at: :DESC)
    elsif @is_trash_box = params[:box] == "trash"
      removed_ids = current_user.message_destinations.where(delete_flag: 1).pluck(:message_id)
      messages = messages.where(id: removed_ids)
    else
      messages = messages.where(id: ids)
    end
    @messages = messages.page(params[:page]).per(10)

    #検索クエリ
    @q = params[:query]
    if @q
      body_ids = []
      @messages.each do |message|
        #プレーンテキストに変換→検索
        body_ids.push(message.id) if message.plaintext_body.include?(@q)
      end
      @messages = @messages.where("title like ?", "%#{@q}%").or(@messages.where(id: body_ids))
    end

    #paginationカウンター
    @total_count = @messages.total_count
    @per_page = @messages.limit_value
    @current_page = @messages.current_page
    @num_pages = @messages.total_pages
    @count_start = (@current_page - 1) * @per_page + 1
    @count_end = @num_pages == 0 ? 0 : (@messages.last_page? ? @total_count : @current_page * @per_page)
  end

  def new
    user = current_user
    @message = user.messages.new
    @user_list = User.all #要変更
  end

  def create
    message = current_user.messages.new(message_params)
    if message.save
      destination_ids = params[:message][:destination].split.map{|i| i.to_i}
      editor_ids = params[:message][:editor].split.map{|i| i.to_i}
      destination_ids.each do |receiver_id|
        unless receiver_id == current_user.id
          receiver = message.message_destinations.new(receiver_id: receiver_id)
          receiver.is_editable = true if editor_ids.include?(receiver_id)
          receiver.save
        end
      end
      #送信者は自動的に受信者・編集者に追加
      message.message_destinations.create(receiver_id: current_user.id, is_editable: true)
      flash[:notice] = "メッセージを作成しました。"
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

    @new_comment = @message.comments.new
    @comments = @message.comments.order(created_at: :DESC).page(params[:page]).per(10)

    #未読→既読の設定
    current_time = Time.zone.now
    @message.receiver_model.update(finished_reading: current_time) if @message.already_read_flag.nil?

    #未表示のコメント・本文がハイライトされる仕様
    last_view = @message.receiver_model.last_viewing
    @viewed_comment = @message.receiver_model.viewed_comment
    @message.receiver_model.update(viewed_comment: @message.number_of_comments, last_viewing: current_time)
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
    message_updated_date = message.updated_at

    if message.update(message_params)
      #内容が更新されていれば最終更新をマーク
      if message.updated_at > message_updated_date
        message.update(update_content_at: message.updated_at, last_update_user_id: current_user.id)
      end

      new_destination_ids = params[:message][:destination].split.map{|i| i.to_i}
      new_editor_ids = params[:message][:editor].split.map{|i| i.to_i}

      #新しい宛先が指定されたら追加する
      destination_ids = message.message_destinations.pluck(:receiver_id)
      (new_destination_ids - destination_ids).each do |receiver_id|
        receiver = message.message_destinations.new(receiver_id: receiver_id)
        receiver.is_editable = true if new_editor_ids.include?(receiver_id)
        receiver.save
      end

      #既存の宛先が無ければ削除する（送信者自身は削除されない）
      (destination_ids - new_destination_ids).each do |receiver_id|
        message.message_destinations.find_by(receiver_id: receiver_id).destroy unless receiver_id == message.user_id
      end

      #編集権限を付与されたユーザーを更新
      editor_ids = message.message_destinations.where(is_editable: true).pluck(:receiver_id)
      (new_editor_ids - editor_ids).each do |editor_id|
        message.message_destinations.find_by(receiver_id: editor_id).update(is_editable: true)
      end

      #編集権限を解除されたユーザーを更新（送信者自身は削除されない）
      (editor_ids - new_editor_ids).each do |editor_id|
        message.message_destinations.find_by(receiver_id: editor_id).update(is_editable: false) unless editor_id == message.user_id
      end

      #添付ファイルの削除
      remove_file_ids = params[:message][:existing_files]
      unless remove_file_ids.nil?
        remove_file_ids.each do |file_id|
          message.attachments.find(file_id).purge
        end
      end

      flash[:notice] = "メッセージを変更しました。"
      redirect_to message_path(message.id)
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
    @receivers = @message.receivers.where(id: @message.message_destinations.pluck(:receiver_id))
    @editors = @receivers.where(id: @message.message_destinations.where(is_editable: true).pluck(:receiver_id))
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
