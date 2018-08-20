class CreateEnvironments < ActiveRecord::Migration[5.1]
  def change
    create_table :environments do |t|
      t.string :name

      t.references :scenario
      t.references :config

      t.timestamps
    end
  end
end
