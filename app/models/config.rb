class Config < ApplicationRecord
  belongs_to :user

  has_many :environments
  has_many :scenarios, through: :environments

  has_many :peers
end
