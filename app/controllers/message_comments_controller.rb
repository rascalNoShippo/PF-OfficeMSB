class MessageCommentsController < ApplicationController
	def create
		message = Message.find(params[:message_id])
		comment = message.comments.new(comment_params)
		comment.commenter_id = current_user.id
		comment.comment_id = message.number_of_comments + 1
		if comment.save
			message.update(number_of_comments: comment.comment_id)
			flash[:notice] = "コメントを書き込みました。"
			redirect_to message_path(params[:message_id])
		end
	end
	
	def destroy
		message = Message.find(params[:message_id])
		comment = MessageComment.find(params[:id])
		if comment.destroy
			message.update(updated_at: Time.zone.now)
		end
		flash[:notice] = "コメント ##{comment_id} を削除しました。"
		redirect_to message_path(params[:message_id])
	end
	
	private

	def comment_params
		params.require(:message_comment).permit(:body, attachments: [])
	end
end
