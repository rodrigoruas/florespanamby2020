class GoogleGeocoding
  include HTTParty
  def initialize(address)
    @address = address
  end

  def get_coordinates
      url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{@address}&key=#{ENV["GOOGLE_GEOCODING_KEY"]}"
      encoded_url = URI.encode(url)
      response = HTTParty.get(encoded_url)
      result = JSON.parse(response.body)
      result["results"].first["geometry"]["location"]
  end

  def get_distance
    store = "Rua Jose Ramon Urtiza, 300 Sao Paulo, SP"
    url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{store}&destination=#{@address}&key=#{ENV["GOOGLE_GEOCODING_KEY"]}"
    encoded_url = URI.encode(url)
    response = HTTParty.get(encoded_url)
    result = JSON.parse(response.body)
    legs = result["routes"].first["legs"]
    legs.first["distance"]["value"]/1000.0
  end
end