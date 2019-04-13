class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :name
      t.integer :quantity
      t.references :survivor, foreign_key: true

      t.timestamps
    end
  end
end
