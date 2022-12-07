class Position < ApplicationRecord
  has_many :user_organizations, dependent: :nullify
end
