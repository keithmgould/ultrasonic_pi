
# Bring in our libraries
require 'wiringpi'


# Bring in our models
Dir.glob(File.join(File.dirname(__FILE__), '/models/*.rb')).each {|f| require f }

# Bring in our config files
Dir.glob(File.join(File.dirname(__FILE__), '/config/*.rb')).each {|f| require f }

# Initialize our Station
station = Station.new(PINS)

#start the station
station.begin



