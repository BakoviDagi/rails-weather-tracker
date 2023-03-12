class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :address, null: false

      t.timestamps
    end
  end
end
