class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def plaintext_body
    body = self.body
    for i in 1..(body.count("<")) do
      body.slice!((body.index("<"))..(body.index(">")))
    end

    for i in 1..(body.count("&nbsp;")) do
      body.slice!("&nbsp;")
    end

    for i in 1..(body.count("\r\n")) do
      body.slice!("\r\n")
    end

    for i in 1..(body.count(" ")) do
      body.slice!(" ")
    end
    return body
  end

  # def comments
  #   Comment.where(class_name: self.class.to_s, item_id: self.id)
  # end

  private

  # ログアウト後のリダイレクト先
  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
