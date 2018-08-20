class CreateConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :configs do |t|
      t.string :name
      t.string :log_title

      t.timestamps
    end
  end
end
