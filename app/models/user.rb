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

	def messages_list(param_box)
	  # メッセージ一覧を取得
    messages = self.received_messages.order(updated_at: :DESC)
    ids = self.message_destinations.where(delete_flag: 0).pluck(:message_id)
    if is_send_box = param_box == "send"
      messages = self.messages.where(id: ids).order(updated_at: :DESC)
    elsif is_trash_box = param_box == "trash"
      removed_ids = self.message_destinations.where(delete_flag: 1).pluck(:message_id)
      messages = messages.where(id: removed_ids)
    else
      messages = messages.where(id: ids)
    end
    return {messages: messages, is_send_box: is_send_box, is_trash_box: is_trash_box}
  end
  
  def edit_organizations(param_orgs, preferred_org_id)
		if User.current_user.is_admin
			new_org_ids = param_orgs.split(";").map{|i| i.split(",").map{|j| j = j.to_i}}.map{|i| i.length == 1 ? i.push(nil) : i}
			name_with_all_org = ""
			new_org_ids.each {|id| name_with_all_org += org_name(*id)}
			self.name_with_all_org = name_with_all_org
			org_ids = self.user_organizations.pluck(:organization_id, :position_id)
			# 新しい組織を追加
        (new_org_ids - org_ids).each do |ids|
          self.user_organizations.create(organization_id: ids[0], position_id: ids[1])
        end
			# 組織を削除
        (org_ids - new_org_ids).each do |ids|
          self.user_organizations.find_by(organization_id: ids[0], position_id: ids[1]).destroy
        end
		end
		# 優先する組織を変更
      if preferred_org_id
        ids = preferred_org_id.split(",")
        preferred_org_id = self.user_organizations.find_by(organization_id: ids[0], position_id: ids[1]).id
        self.update(preferred_org_id: preferred_org_id)
      else
        self.update(preferred_org_id: nil)
      end
	end
	
	def create_organizaions(param_orgs, preferred_org_id)
		new_org_ids = param_orgs.split(";").map{|i| i.split(",").map{|j| j = j.to_i}}
		name_with_all_org = ""
		new_org_ids.each {|id| name_with_all_org += org_name(*id)}
		self.name_with_all_org = name_with_all_org
		#組織を追加
			new_org_ids.each do |ids|
				self.user_organizations.create(organization_id: ids[0], position_id: ids[1])
			end
		# 優先する組織を変更
      if preferred_org_id
        ids = preferred_org_id.split(",")
        preferred_org_id = self.user_organizations.find_by(organization_id: ids[0], position_id: ids[1]).id
        self.update(preferred_org_id: preferred_org_id)
      end
  end
  
  def self.search(params_queries)
		if params_queries
			queries = params_queries.split.map{|x| x = "%#{x}%"}
			column = []
			queries.count.times{|a| column.push("(name like ? or name_with_all_org like ? or name_reading like ?)")}
			column = column.join(" and ")
			queries = (queries * 3).sort
			return queries.length == 0 ? self : self.where(column, *(queries))
		else
      return self
		end
	end
		
	private
	
  def org_name(organization_id, position_id = nil)
    org = Organization.find(organization_id).name
    position = Position.find(position_id).name if position_id
    return "（#{org}#{"・#{position}" if position_id}）"
  end
end