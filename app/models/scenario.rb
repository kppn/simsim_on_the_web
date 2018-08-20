class Scenario < ApplicationRecord
  has_one :environment
  has_one :config, through: :environment

  has_one :extra
end
