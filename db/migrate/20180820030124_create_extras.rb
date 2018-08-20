class CreateExtras < ActiveRecord::Migration[5.1]
  def change
    create_table :extras do |t|
      t.string :name
      t.string :content
      t.references :scenario, foreign_key: true

      t.timestamps
    end
  end
end
