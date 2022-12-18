class BulletinBoard < ApplicationRecord
	belongs_to :user
	has_many :comments, -> { where(class_name: "BulletinBoard") }, foreign_key: "item_id" , dependent: :destroy
	has_many :favorites, -> { where(class_name: "BulletinBoard") }, foreign_key: "item_id" , dependent: :destroy
	has_many :view_flags, class_name: "BulletinBoardViewFlag", dependent: :destroy
	belongs_to :last_update_user, class_name: "User", optional: true
	has_many_attached :attachments

	def already_read_flag
		self.view_flags.find_by(user_id: User.current_user.id)
	end

	def set_already_read
		view_flag = self.already_read_flag
			if view_flag.nil?
				last_view = nil
				self.view_flags.create(user_id: User.current_user.id, viewed_comment: self.number_of_comments)
			else
				last_view = view_flag.updated_at
				view_flag.update(viewed_comment: self.number_of_comments, updated_at: Time.zone.now)
			end
		# 最後の閲覧後に内容の更新があったかをtrueかfalseで返す（未読または未更新はnil）
			return last_view < self.update_content_at unless last_view.nil? || self.update_content_at.nil?
	end

	def self.search(params_queries)
    if params_queries
      queries = params_queries.split
      ids = []
      self.all.each do |article|
        #プレーンテキストに変換→検索
          ids.push(article.id) if queries.all?{|x| article.plaintext_body.include?(x) || article.title.include?(x)}
      end
      self.where(id: ids)
    else
    	self.all
    end
	end

end
