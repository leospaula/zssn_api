class CreateSurvivors < ActiveRecord::Migration[5.2]
  def change
    create_table :survivors do |t|
      t.string :name
      t.integer :age
      t.integer :gender
      t.integer :infection_count, default: 0
      t.jsonb :last_location, default: {}

      t.timestamps
    end
  end
end
