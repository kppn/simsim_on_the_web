class AddUserIdToConfig < ActiveRecord::Migration[5.1]
  def change
    add_reference :configs, :user, foreign_key: true
  end
end
