require 'wiringpi'

require "#{File.dirname(__FILE__)}/sensor.rb"

ECHO = 24
TRIG = 23

ECHO2 = 25
TRIG2 = 22


wiring_io = WiringPi::GPIO.new(WPI_MODE_GPIO)

sensor = Sensor.new(TRIG, ECHO, wiring_io)
sensor2 = Sensor.new(TRIG2, ECHO2, wiring_io)

puts "resetting sensors"
sensor.reset
sensor2.reset
sleep(2)
puts "here we go..."
loop do
  distance = sensor.distance
  puts "distance: #{distance}"
  sleep(0.05)
  distance2 = sensor2.distance
  puts "distance2: #{distance2}"
  sleep(0.05)
end

