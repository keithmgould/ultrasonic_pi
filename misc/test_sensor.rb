require 'wiringpi'

require "#{File.dirname(__FILE__)}/sensor.rb"

unless ARGV.size == 4
  puts "Please enter trigger and echo pins for sensor 1 and 2."
  puts "(s1 t) (s1 e) (s2 t) (s2 e)"
  puts "ex: ruby distance.rb 2 3 4 5"
  exit
end


trigger1 = ARGV[0].to_i
echo1 = ARGV[1].to_i

trigger2 = ARGV[2].to_i
echo2 = ARGV[3].to_i

wiring_io = WiringPi::GPIO.new(WPI_MODE_GPIO)

sensor = Sensor.new(trigger1, echo1, wiring_io)
sensor2 = Sensor.new(trigger2, echo2, wiring_io)

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

