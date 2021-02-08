require "bundler/setup"
Bundler.require(:default)

require "sinatra/json"
require "sinatra/reloader" if development?

require_relative "starlink"

set :public_folder, __dir__ + "/frontend/build"

get "/" do
  send_file File.expand_path("index.html", settings.public_folder)
end

get "/v1/satellites" do
  latitude = params["latitude"].to_f
  longitude = params["longitude"].to_f
  n = params["n"].to_i

  results = Starlink::Constellation.close_to(latitude, longitude, n)
  json results.as_json
end
