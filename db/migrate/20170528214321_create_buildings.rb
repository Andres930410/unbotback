class CreateBuildings < ActiveRecord::Migration[5.0]
  def change
    create_table :buildings do |t|
      t.string :number, null: false
      t.string :name, null: false
      t.string :nickname, null: true
      t.integer :year, null: true
      t.decimal :lat, null: false, unique: true
      t.decimal :lng, null: false, unique: true
      t.text :history, null: true
      t.text :image
      t.text :close_to, null: true

      t.timestamps
    end
  end
end
