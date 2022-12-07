class Organization < ApplicationRecord
  has_many :user_organizations, dependent: :destroy
  
end
