class CommentsController < ApplicationController
	def create
		item = params[:class_name].constantize.find(params[:item_id])
		comment = item.comments.new(comment_params)
		comment.commenter_id = current_user.id
		comment.comment_id = item.number_of_comments + 1
		if comment.save
			item.update(number_of_comments: comment.comment_id)
			flash[:notice] = "コメントを書き込みました。"
			redirect_to item
		end
	end
	
	def destroy
		item = params[:class_name].constantize.find(params[:item_id])
		comment_id = params[:comment_id]
		comment = item.comments.find_by(comment_id: comment_id)
		if comment.destroy
			item.update(updated_at: Time.zone.now)
		end
		flash[:notice] = "コメント ##{comment_id} を削除しました。"
		redirect_to item
	end
	
	private

	def comment_params
		params.require(:comment).permit(:body, attachments: [])
	end
end