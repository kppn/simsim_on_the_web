class Scenario < ApplicationRecord
  belongs_to :user

  has_one :environment
  has_one :config, through: :environment

  has_one :extra, :dependent => :destroy
end
