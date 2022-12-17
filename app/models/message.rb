class Message < ApplicationRecord
	belongs_to :user
	belongs_to :last_update_user, class_name: "User", foreign_key: "last_update_user_id", optional: true
	has_many :message_destinations, dependent: :destroy
	has_many :receivers, through: :message_destinations
	has_many :comments, -> { where(class_name: "Message") }, foreign_key: "item_id", dependent: :destroy
	has_many :favorites, -> { where(class_name: "Message") }, foreign_key: "item_id" , dependent: :destroy
	has_many_attached :attachments

	def receiver_model
		self.message_destinations.find_by(receiver_id: User.current_user.id)
	end

	def already_read_flag
		self.receiver_model.finished_reading
	end

	def editors
		editor_ids = self.message_destinations.where(is_editable: true).pluck(:receiver_id)
		self.receivers.where(id: editor_ids)
	end

	def finished_reading(receiver)
		self.message_destinations.find_by(reeiver_id: receiver.id).finished_reading
	end

	def recycled?
		self.message_destinations.find_by(receiver_id: User.current_user).delete_flag == 1
	end

	def set_already_read
    # 未読→既読の設定
			current_time = Time.zone.now
			self.receiver_model.update(finished_reading: current_time) if self.already_read_flag.nil?
    # 未表示のコメント・本文がハイライトされる仕様
			last_view = self.receiver_model.last_viewing
			self.receiver_model.update(viewed_comment: self.number_of_comments, last_viewing: current_time)
		# 最後の閲覧後に内容の更新があったかをtrueかfalseで返す（未読または未更新はnil）
			return (last_view < self.update_content_at unless last_view.nil? || self.update_content_at.nil?)
	end

	def destination_create(destination_params, editor_params)
		user_id = self.user.id
    destination_ids = destination_params.split.map{|i| i.to_i}
    editor_ids = editor_params.split.map{|i| i.to_i}
    destinations = []
    now = Time.zone.now
    destination_ids.each do |receiver_id|
      destinations.push({receiver_id: receiver_id, is_editable: (receiver_id == user_id ? true : editor_ids.include?(receiver_id)), created_at: now, updated_at: now})
    end
    self.message_destinations.insert_all!(destinations)
    #送信者は自動的に受信者・編集者に追加
			self.message_destinations.create(receiver_id: current_user.id, is_editable: true) unless destination_ids.include?(user_id)
	end

	def destination_update(destination_params, editor_params)
		user_id = self.user.id
		new_destination_ids = destination_params.split.map{|i| i.to_i}
		new_editor_ids = editor_params.split.map{|i| i.to_i}
    #新しい宛先が指定されたら追加する
			destination_ids = self.message_destinations.pluck(:receiver_id)
			add_destinations = []
			now = Time.zone.now
			(new_destination_ids - destination_ids).each do |receiver_id|
			  add_destinations.push({receiver_id: receiver_id, is_editable: (receiver_id == user.id ? true : new_editor_ids.include?(receiver_id)), created_at: now, updated_at: now})
			end
			self.message_destinations.insert_all!(add_destinations) if add_destinations.length > 1
    #既存の宛先が無ければ削除する（送信者自身は削除されない）
			delete_destinations = (destination_ids - new_destination_ids)
			delete_destinations.delete(user_id)
			self.message_destinations.where(receiver_id: delete_destinations).delete_all if delete_destinations.length > 1
    #編集権限を付与されたユーザーを更新
			editor_ids = self.message_destinations.where(is_editable: true).pluck(:receiver_id)
			self.message_destinations.where(receiver_id: (new_editor_ids - editor_ids)).update_all(is_editable: true)
    #編集権限を解除されたユーザーを更新（送信者自身は削除されない）
			delete_permission_editing = (editor_ids - new_editor_ids)
			delete_permission_editing.delete(user_id)
			self.message_destinations.where(receiver_id: delete_permission_editing).update_all(is_editable: false)
	end

	def self.search(params_query)
    if params_query
      q = params_query.split
      ids = []
      self.all.each do |message|
        #プレーンテキストに変換→検索
          ids.push(message.id) if q.all?{|x| message.plaintext_body.include?(x) || message.title.include?(x)}
      end
      self.where(id: ids)
    else
    	self.all
    end
  end

end
