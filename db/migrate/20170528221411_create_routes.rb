class CreateRoutes < ActiveRecord::Migration[5.0]
  def change
    create_table :routes do |t|
      t.references :building_one, class_name: "building"
      t.references :building_two, class_name: "building"
      t.text :image

      t.timestamps
    end
    change_table :routes do |t|
      add_foreign_key :routes, :buildings, column: :building_one_id
      add_foreign_key :routes, :buildings, column: :building_two_id
    end

    add_index :routes, [:building_one_id,:building_two_id] ,unique: true
  end
end
