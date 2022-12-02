class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  validates :login_name, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
	has_one_attached :image

  has_many :messages, dependent: :destroy
  has_many :message_destinations, foreign_key: :receiver_id, dependent: :destroy
  has_many :received_messages, through: :message_destinations, source: :message

  has_many :comments, foreign_key: :commenter_id, dependent: :destroy

  has_many :bulletin_boards, foreign_key: "sender_id", dependent: :destroy
  # has_many :bulletin_board_comments, foreign_key: :commenter_id, dependent: :destroy
  has_many :bulletin_board_view_flags, dependent: :destroy

  has_many :favorites, dependent: :destroy

  has_one :config, class_name: "UserConfig", foreign_key: "user_id", dependent: :destroy
  
  def self.current_user=(user)
    Thread.current[:user] = user # 現在のスレッドにuserを設定するメソッド
  end

  def self.current_user
    Thread.current[:user] # 現在のスレッドに登録されているユーザーを呼び出す
  end

  def icon
    class_name = self == User.current_user ? "text-success" : "text-primary"
    class_name = "text-lightgray" if self.is_invalid
    "<i class='fas fa-user mr-1 #{class_name}'></i>".html_safe
  end

  def get_image
    if is_invalid
      "invalid.jpg"
    elsif image.attached?
      image
    else
      "no_img.jpg"
    end
  end

  def name
    "#{self[:name]}#{"（無効化されたユーザー）" if self.is_invalid}"
  end


  def update_with_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank?
        params.delete(:password)
        params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update(params, *options)

    clean_up_passwords
    result
  end

end
