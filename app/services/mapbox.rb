class Mapbox
    include HTTParty
    def initialize(address)
      @address = address
    end
  
    def get_coordinates
        url = "https://api.mapbox.com/geocoding/v5/mapbox.places/#{@address}.json?&access_token=#{ENV["MAPBOX_API_KEY"]}"
        encoded_url = URI.encode(url)
        response = HTTParty.get(encoded_url)
        result = JSON.parse(response)
        result["features"].first["geometry"]["coordinates"]
    end
  end