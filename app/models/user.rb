class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  validates :login_name, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
	has_one_attached :image

  # アソシエーション ここから
    has_many :messages, dependent: :destroy
    has_many :message_destinations, foreign_key: :receiver_id, dependent: :destroy
    has_many :received_messages, through: :message_destinations, source: :message
  
    has_many :comments, foreign_key: :commenter_id, dependent: :destroy
  
    has_many :bulletin_boards, dependent: :destroy
    has_many :bulletin_board_view_flags, dependent: :destroy
    has_many :schedules, dependent: :destroy
  
    has_many :favorites, dependent: :destroy
  
    has_many :user_organizations, dependent: :destroy
    has_many :organizations, through: :user_organizations
    has_many :positions, through: :user_organizations
  
    belongs_to :preferred_org, class_name: "UserOrganization", optional: true
  
    has_one :config, class_name: "UserConfig", foreign_key: "user_id", dependent: :destroy
  # アソシエーション ここまで


  def self.current_user=(user)
    Thread.current[:user] = user # 現在のスレッドにuserを設定するメソッド
  end

  def self.current_user
    Thread.current[:user] # 現在のスレッドに登録されているユーザーを呼び出す
  end

  def icon
    # ユーザーアイコン 自分：緑，他人：青
    class_name = self == User.current_user ? "text-success" : "text-primary"
    class_name = "text-lightgray" if self.is_invalid
    "<i class='fas fa-user mr-1 #{class_name}'></i>".html_safe
  end

  def get_image
    # ユーザー画像（コメント欄等） 未登録・無効ユーザーは専用画像を表示
    if is_invalid
      "invalid.jpg"
    elsif image.attached?
      image
    else
      "no_img.jpg"
    end
  end

  def name
    # ユーザー名を “名前 役職（組織）” の形で表示 
    name_org = "#{self[:name]}"
    if self.preferred_org_id
      if self.preferred_org.position_id
        name_org += " #{self.preferred_org.position.name}"
      end
      name_org += "（#{self.preferred_org.organization.name}）"
    end
    name_org += "（無効化されたユーザー）" if self.is_invalid
    return name_org
  end

  def update_with_password(params, *options)
    # パスワードの変更
    params.delete(:current_password)

    if params[:password].blank?
        params.delete(:password)
        params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update(params, *options)

    clean_up_passwords
    result
  end

	def messages_list(params_box)
	  # メッセージ一覧を取得
    messages = self.received_messages.order(updated_at: :DESC)
    ids = self.message_destinations.where(delete_flag: 0).pluck(:message_id)
    if is_send_box = params_box == "send"
      messages = self.messages.where(id: ids).order(updated_at: :DESC)
    elsif is_trash_box = params_box == "trash"
      removed_ids = self.message_destinations.where(delete_flag: 1).pluck(:message_id)
      messages = messages.where(id: removed_ids)
    else
      messages = messages.where(id: ids)
    end
    return {messages: messages, is_send_box: is_send_box, is_trash_box: is_trash_box}
  end
end
