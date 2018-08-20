class CreatePeers < ActiveRecord::Migration[5.1]
  def change
    create_table :peers do |t|
      t.string :name, null: true
      t.string :own_ip
      t.integer :own_port
      t.string :dst_ip
      t.integer :dst_port
      t.string :protocol

      t.references :config, foreign_key: true

      t.timestamps
    end
  end
end
