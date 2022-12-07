class UserOrganization < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  belongs_to :position, optional: true
  has_one :preferred, class_name: "User", foreign_key: "preferred_org_id", dependent: :nullify


  def ids
    unless self.position_id
      return self.organization_id
    else
      return "#{self.organization_id},#{self.position_id}"
    end
  end

  def name
    unless self.position_id
      return self.organization.name
    else
      return "#{self.organization.name}（#{self.position.name}）"
    end
  end

end
