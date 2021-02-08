#!/bin/env ruby
require_relative "starlink"

if ARGV.length != 3
  puts "Usage: task_1.rb [latitude] [longitude] [N]"
  exit 1
end

Latitude = ARGV[0].to_f
Longitude = ARGV[1].to_f
N_results = ARGV[2].to_i

begin
  results = Starlink::Constellation.close_to(Latitude, Longitude, N_results).satellites

  puts "#\tId\t\t\t\tDistance"
  results.each_with_index do |r, i|
    puts "%i\t%s\t%.2fm" % [i, r.id, r.distance]
  end
rescue RuntimeError => e
  p e
end
