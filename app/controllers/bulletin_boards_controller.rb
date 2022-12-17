class BulletinBoardsController < ApplicationController

	def index
		@articles = BulletinBoard.order(updated_at: :DESC)
    # 検索
			@q = params[:query]
		@articles = @articles.search(@q).page(params[:page]).per(current_user.config.number_of_displayed_items)
	end

	def show
		@article = BulletinBoard.find(params[:id])
		@new_comment = @article.comments.new
		@comments = @article.comments.order(created_at: :DESC).page(params[:page]).per(current_user.config.number_of_displayed_comments)
    # 未読本文・コメントをハイライト
			@viewed_comment = @article.already_read_flag.viewed_comment if @article.already_read_flag
			@unread_after_update = @article.set_already_read
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
			article.delete_attachments(params[:bulletin_board][:existing_files])
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
