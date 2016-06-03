require 'awesome_print'
require 'json'
require 'net/http'
require 'uri'
require 'xmlrpc/server'

# Déclaration du serveur
server = XMLRPC::Server.new 1234

# http://www.latlong.net/
# Los Angeles 34.052234 -118.243685

# Handler de reverse géolocalisation
server.add_handler('rpc_webservice.lat_lon_info') do |lat, lon|
  city_info = JSON.parse %x(geocode -j #{lat}, #{lon})

  Hash[
    city: city_info.dig('results', 0, 'address_components', 3, 'long_name'),
    country: city_info.dig('results', 0, 'address_components', 6, 'long_name')
  ].to_json
end

# http://api.openweathermap.org/pollution/v1/co/34.0,-118/current.json?appid=a3573dcb30e93ad67687f4fb70aa87c6
# Handler de récupération du niveau de CO2
server.add_handler('rpc_webservice.co2') do |lat, lon|
  response = Net::HTTP.get(URI.parse("http://api.openweathermap.org/pollution/v1/co/#{lat},#{lon}/current.json?appid=a3573dcb30e93ad67687f4fb70aa87c6"))
  # ap response

  # CO2
  JSON.parse(response)['data'][0]['value']
end

# http://api.openweathermap.org/v3/uvi/34,-118/current.json?appid=a3573dcb30e93ad67687f4fb70aa87c6
# Handler de récupération du niveau d'UV
server.add_handler('rpc_webservice.uv') do |lat, lon|
  response = Net::HTTP.get(URI.parse("http://api.openweathermap.org/v3/uvi/#{lat},#{lon}/current.json?appid=a3573dcb30e93ad67687f4fb70aa87c6"))
  # ap response

  # UV
  JSON.parse(response)['data']
end

# Lancement du serveur
server.serve
