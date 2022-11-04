class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  validates :login_name, presence: true, uniqueness: true
  validates :password, presence: true

  has_many :messages, dependent: :destroy
  has_many :message_destinations, foreign_key: :receiver_id, dependent: :destroy
  has_many :received_messages, through: :message_destinations, source: :message
  has_many :message_comments, foreign_key: :commenter_id, dependent: :destroy

  def self.current_user=(user)
    Thread.current[:user] = user # 現在のスレッドにuserを設定するメソッド
  end

  def self.current_user
    Thread.current[:user] # 現在のスレッドに登録されているユーザーを呼び出す
  end

  def icon
    class_name = self == User.current_user ? "text-success" : "text-primary"
    "<i class='fa-solid fa-user mr-1 #{class_name}'></i>".html_safe
  end
end
