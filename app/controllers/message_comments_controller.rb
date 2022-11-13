class MessageCommentsController < ApplicationController
	def create
		message = Message.find(params[:message_id])
		comment = message.comments.new(comment_params)
		comment.commenter_id = current_user.id
		comment.comment_id = message.number_of_comments + 1
		if comment.save
			message.update(number_of_comments: comment.comment_id)
			redirect_to message_path(params[:message_id])
		end
	end
	
	def destroy
		message = Message.find(params[:message_id])
		comment = MessageComment.find(params[:id])
		if comment.destroy
			message.update(updated_at: Time.zone.now)
		end
		redirect_to message_path(params[:message_id])
	end
	
	private

	def comment_params
		params.require(:message_comment).permit(:body, attachments: [])
	end
end
