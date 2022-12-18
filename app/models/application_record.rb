class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def plaintext_body
    body = self.body
    return "" if body.nil?
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
  
  def favorite_find?
    self.favorites.find_by(user_id: User.current_user.id)
  end
  
  def delete_attachments(remove_file_params)
    #添付ファイルの削除
    unless remove_file_params.nil?
      remove_file_params.each do |file_id|
        self.attachments.find(file_id).purge
      end
    end
  end
  
  # def self.find(id)
  #   # 存在しないIDでもActiveRecordを返す
  #   unless self.exists?(id: id)
  #     return self.new(id: id)
  #   end
  #   super
  # end
  

  private

  # ログアウト後のリダイレクト先
  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
