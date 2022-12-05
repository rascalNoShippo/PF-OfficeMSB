class BulletinBoardsController < ApplicationController

	def index
		@articles = BulletinBoard.order(updated_at: :DESC).page(params[:page]).per(current_user.config.number_of_displayed_items)

    #検索クエリ
    @q = params[:query]
    if @q
      body_ids = []
      @articles.each do |article|
        #プレーンテキストに変換→検索
        body_ids.push(article.id) if article.plaintext_body.include?(@q)
      end
      @articles = @articles.where("title like ?", "%#{@q}%").or(@articles.where(id: body_ids))
    end

	end

	def show
		@article = BulletinBoard.find(params[:id])
		@new_comment = @article.comments.new
		@comments = @article.comments.order(created_at: :DESC).page(params[:page]).per(current_user.config.number_of_displayed_comments)
		@form_url
		@delete_url
		view_flag = @article.already_read_flag

		#既読をマーク, 未表示のコメント・本文がハイライトされる仕様
		if view_flag.nil?
			@viewed_comment = 0
			last_view = nil
			@article.view_flags.create(user_id: current_user.id, viewed_comment: @article.number_of_comments)
		else
			@viewed_comment = view_flag.viewed_comment
			last_view = view_flag.updated_at
			view_flag.update(viewed_comment: @article.number_of_comments, updated_at: Time.zone.now)
		end
    @unread_after_update = last_view < @article.update_content_at unless last_view.nil? || @article.update_content_at.nil?

	end

	def new
		@article = current_user.bulletin_boards.new
	end

	def create
		article = current_user.bulletin_boards.new(bulletin_board_params)

		if article.save
			flash[:notice] = "掲示を作成しました。"
			redirect_to bulletin_board_path(article.id)
		end
	end

	def edit
		@article = BulletinBoard.find(params[:id])
		@user = @article.user
		raise Forbidden if current_user != @user && !current_user.is_admin
	end

	def update
		article = BulletinBoard.find(params[:id])
		article_updated_date = article.updated_at

		if article.update(bulletin_board_params)
			flash[:notice] = "掲示を更新しました。"
			#内容が更新されていれば最終更新をマーク
			if article.updated_at > article_updated_date
				article.update(update_content_at: article.updated_at, last_update_user_id: current_user.id)
			end
			redirect_to bulletin_board_path
		end
	end

	def destroy
		article = BulletinBoard.find(params[:id])
		article.destroy
		flash[:notice] = "掲示“#{article.title}”を削除しました。"
		redirect_to bulletin_boards_path
	end

  private

	def bulletin_board_params
		params.require(:bulletin_board).permit(:title, :body, :is_commentable, attachments: [])
	end
end
