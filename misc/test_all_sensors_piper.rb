require 'pi_piper'

# bring in our pinouts
require "#{File.dirname(__FILE__)}/../config/pinout.rb"

# bing our sensor class
require "#{File.dirname(__FILE__)}/../models/box_sensor.rb"

@sensors = []

[:entry_sensor, :exit_sensor, :inside_sensor].each do |sensor|
  @sensors << BoxSensor.new(PINS[sensor][:trigger], PINS[sensor][:echo], sensor.to_s)
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

