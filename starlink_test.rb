require "bundler/setup"
Bundler.require(:test)

require_relative "starlink"

VCR.configure do |config|
  config.cassette_library_dir = "fixtures"
  config.hook_into :webmock
end

class TestStarlink < Minitest::Test
  def test_satellites_all
    VCR.use_cassette("satellites") do
      s = Starlink::Satellite.all
      assert_equal s.length, 961
    end
  end

  def test_constellation_closest
    VCR.use_cassette("satellites") do
      s = Starlink::Constellation.close_to(47.1923146, -114.0890228, 10)
      assert_equal s.satellites.length, 10
      assert_equal s.satellites.first.distance, 539389.1137241827
      assert_equal s.satellites.last.distance, 782410.0332429034
    end
  end

  def test_constellation_as_json
    s = [
      Starlink::Satellite.new("id.1", 1.0, 2.0),
      Starlink::Satellite.new("id.2", 1.0, 2.0),
    ]
    c = Starlink::Constellation.new(s)

    # I'd normally stub Satellite's as_json and then only validate
    # it's being called for all instances in the constellation.
    assert_equal c.as_json, [
      { id: "id.1", latitude: 1.0, longitude: 2.0 },
      { id: "id.2", latitude: 1.0, longitude: 2.0 },
    ]
  end

  def test_satellites_as_json
    s = Starlink::Satellite.new("id.1", 1.0, 2.0)
    assert_equal s.as_json, { id: "id.1", latitude: 1.0, longitude: 2.0 }
  end
end
