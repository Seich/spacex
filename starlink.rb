require "bundler/setup"
Bundler.require(:default)

require "net/http"
require "uri"
require "json"

module Starlink
  class Constellation
    @satellites = []

    attr_reader :satellites

    def initialize(satellites)
      @satellites = [satellites].flatten
    end

    def self.close_to(lat, lon, n)
      results = Satellite.all.map do |s|
        s.distance = Haversine.distance(s.latitude, s.longitude, lat, lon).to_meters
        s
      end

      Constellation.new results.sort_by(&:distance).first(n)
    end

    def as_json
      @satellites.map(&:as_json)
    end
  end

  class Satellite
    @id = ""
    @latitude = nil
    @longitude = nil
    @distance = 0

    attr_reader :latitude, :longitude, :id
    attr_accessor :distance

    def initialize(id, lat, lon)
      @id = id
      @latitude = lat
      @longitude = lon
    end

    def self.all
      endpoint = URI.parse "https://api.spacexdata.com/v4/starlink"
      get_satellites = Net::HTTP.get_response(endpoint)

      if get_satellites.code != "200"
        raise "Fetching satellites failed."
      end

      satellites = JSON.parse(get_satellites.body)
      satellites.reject! { |s| s["latitude"].nil? || s["longitude"].nil? }
      satellites.map { |s| Satellite.new(s["id"], s["latitude"], s["longitude"]) }
    end

    def as_json
      {
        id: @id,
        latitude: @latitude,
        longitude: @longitude,
      }
    end
  end
end
