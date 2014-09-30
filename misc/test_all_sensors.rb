require 'wiringpi'

# bring in our pinouts
require "#{File.dirname(__FILE__)}/../pinout.rb"

# bing our sensor class
require "#{File.dirname(__FILE__)}/../models/sensor.rb"

wiring_io = WiringPi::GPIO.new(WPI_MODE_GPIO)

@sensors = []

[:entry_sensor, :exit_sensor, :inner_sensor].each do |sensor|
  @sensors << Sensor.new(PINS[sensor][:trigger], PINS[sensor][:echo], wiring_io, sensor.to_s)
end

PINS[:beam_sensors].each_with_index do |sensor, index|
  @sensors << Sensor.new(sensor[:trigger], sensor[:echo], wiring_io, "beam_#{index + 1}")
end

puts "resetting sensors"
@sensors.each { |sensor| sensor.reset }
sleep(2)
puts "here we go..."

loop do
  @sensors.each do |sensor|
    distance = sensor.distance
    puts "distance: #{distance} for sensor #{sensor.name}" if distance < 40
    sleep(0.025)
  end
end

