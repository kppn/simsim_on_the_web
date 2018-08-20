class Config < ApplicationRecord
  has_many :environments
  has_many :scenarios, through: :environments

  has_many :peers
end
