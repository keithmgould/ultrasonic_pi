
# Bring in our GPIO/SPI library
require 'pi_piper'
include PiPiper

# Bring in our initializers
Dir.glob(File.join(File.dirname(__FILE__), '/initializers/*.rb')).each {|f| require f }

# Bring in our models
Dir.glob(File.join(File.dirname(__FILE__), '/models/*.rb')).each {|f| require f }

# Bring in our config files
Dir.glob(File.join(File.dirname(__FILE__), '/config/*.rb')).each {|f| require f }

# Initialize our Station
station = Station.new(PINS)

#start the station
station.begin



