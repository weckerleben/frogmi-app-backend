namespace :fetch do
    desc "Fetch and persist earthquake data"
    task earthquake_data: :environment do
      require 'json'
      require 'httparty'

      url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson"
      response = HTTParty.get(url)
      json = JSON.parse(response.body)
      
    #   file_path = Rails.root.join('lib', 'data', 'all_month.geojson')
    #   json = JSON.parse(File.read(file_path))
    
      json["features"].each do |feature|
        data = feature["properties"]
  
        # Validaciones
        next if data["title"].nil? || data["url"].nil? || data["place"].nil? || data["magType"].nil? || feature["geometry"]["coordinates"][0].nil? || feature["geometry"]["coordinates"][1].nil?
        next if data["mag"] < -1.0 || data["mag"] > 10.0 || feature["geometry"]["coordinates"][1] < -90.0 || feature["geometry"]["coordinates"][1] > 90.0 || feature["geometry"]["coordinates"][0] < -180.0 || feature["geometry"]["coordinates"][0] > 180.0
  
        # Verificar duplicados
        next if Earthquake.exists?(external_id: feature["id"])
  
        # Persistir datos sismológicos
        earthquake = Earthquake.new(
          external_id: feature["id"],
          magnitude: data["mag"],
          place: data["place"],
          time: Time.at(data["time"] / 1000),
          url: data["url"],
          tsunami: data["tsunami"],
          mag_type: data["magType"],
          title: data["title"],
          longitude: feature["geometry"]["coordinates"][0],
          latitude: feature["geometry"]["coordinates"][1]
        )
        earthquake.save
      end
    end
  end
  