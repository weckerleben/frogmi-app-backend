class AddExternalIdToEarthquakes < ActiveRecord::Migration[7.1]
  def change
    add_column :earthquakes, :external_id, :string
  end
end
