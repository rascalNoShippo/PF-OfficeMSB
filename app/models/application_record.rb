class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  private

  # ログアウト後のリダイレクト先
  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
