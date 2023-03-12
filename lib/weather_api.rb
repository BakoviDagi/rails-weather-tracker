class WeatherApi
  def self.get_weather(address)
    query = CGI.escape(address)
    api_key = "8acde4fb731042bd931215156231103"
    response = Excon.get("https://api.weatherapi.com/v1/forecast.json?key=#{api_key}&q=#{query}&days=7&aqi=no&alerts=no")

    return nil if response.status != 200
    JSON.parse(response.body)
  end
end