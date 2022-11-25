class BulletinBoardCommentsController < ApplicationController
	def create
		article = BulletinBoard.find(params[:bulletin_board_id])
		comment = article.comments.new(comment_params)
		comment.commenter_id = current_user.id
		comment.comment_id = article.number_of_comments + 1
		if comment.save
			article.update(number_of_comments: comment.comment_id)
			redirect_to bulletin_board_path(article.id)
		end

	end
	def destroy
		comment = BulletinBoardComment.find(params[:id])
		comment.destroy
		redirect_to bulletin_board_path(params[:bulletin_board_id])
	end


	private

	def comment_params
		params.require(:bulletin_board_comment).permit(:body, attachments: [])
	end

end
