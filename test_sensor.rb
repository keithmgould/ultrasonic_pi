require 'wiringpi'

require "#{File.dirname(__FILE__)}/sensor.rb"

TRIG = 23
ECHO = 24

wiring_io = WiringPi::GPIO.new(WPI_MODE_GPIO)


sensor = Sensor.new(TRIG, ECHO, wiring_io)

puts "resetting sensors"
sensor.reset
sleep(2)
puts "here we go..."
loop do
  distance = sensor.distance
  puts "distance: #{distance}"
  sleep(0.5)
end
