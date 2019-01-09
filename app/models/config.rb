class Config < ApplicationRecord
  belongs_to :user

  has_many :environments
  has_many :scenarios, through: :environments

  has_many :peers, :dependent => :destroy

  accepts_nested_attributes_for :peers, allow_destroy: true
end
