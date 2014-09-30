
# Bring in our libraries
require 'wiringpi'


# Bring in our models
Dir.glob(File.join(File.dirname(__FILE__), '/models/*.rb')).each {|f| require f }

# Declare our pinout
require "#{File.dirname(__FILE__)}/pinout.rb"

# Initialize our Station
station = Station.new(PINS)

#start the station
station.begin



