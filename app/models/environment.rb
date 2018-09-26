class Environment < ApplicationRecord
  belongs_to :user

  belongs_to :scenario
  belongs_to :config
end
