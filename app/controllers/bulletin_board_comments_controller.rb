class BulletinBoardCommentsController < ApplicationController
	def create
		article = BulletinBoard.find(params[:bulletin_board_id])
		comment = article.comments.new(comment_params)
		comment.commenter_id = current_user.id
		comment.comment_id = article.number_of_comments + 1
		if comment.save
			article.update(number_of_comments: comment.comment_id)
			flash[:notice] = "コメントを書き込みました。"
			redirect_to bulletin_board_path(article.id)
		end

	end
	def destroy
		article = BulletinBoard.find(params[:bulletin_board_id])
		comment = BulletinBoardComment.find(params[:id])
		comment_id = comment.comment_id
		if comment.destroy
			article.update(updated_at: Time.zone.now)
		end
		flash[:notice] = "コメント ##{comment_id} を削除しました。"
		redirect_to bulletin_board_path(params[:bulletin_board_id])
	end


	private

	def comment_params
		params.require(:bulletin_board_comment).permit(:body, attachments: [])
	end

end
