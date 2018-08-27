class AddUserIdToEnvironment < ActiveRecord::Migration[5.1]
  def change
    add_reference :environments, :user, foreign_key: true
  end
end
