class CreateEarthquakes < ActiveRecord::Migration[6.0]
  def change
    create_table :earthquakes do |t|
      t.float :magnitude, null: false
      t.string :place, null: false
      t.datetime :time, null: false
      t.string :url, null: false
      t.boolean :tsunami, default: false
      t.string :mag_type
      t.string :title, null: false
      t.float :longitude, null: false
      t.float :latitude, null: false

      t.timestamps
    end
  end
end
