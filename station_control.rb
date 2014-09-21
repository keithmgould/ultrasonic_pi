
# Bring in our libraries
require 'wiringpi'
require 'state_machine'

# Bring in our models
Dir.glob(File.join(File.dirname(__FILE__), '/models/*.rb')).each {|f| require f }

# Declare our pinout
pins = { buzzer: 2, reset: 3, status: 4 }
pins[:entry_sensor] = { trigger: 8, echo: 9 }
pins[:exit_sensor]  = { trigger: 10, echo: 11 }
pins[:beam_sensors] = [
                  {trigger: 14,  echo: 15},
                  {trigger: 17, echo: 18},
                  {trigger: 22, echo: 23},
                  {trigger: 24, echo: 25},
                  {trigger: 7, echo: 27},
               ]

# Initialize our Station
station = Station.new(pins)

#start the station
station.begin



