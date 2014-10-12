require 'pi_piper'

unless ARGV.size == 2
  puts "Please enter trigger and echo pins."
  puts "ex: ruby distance.rb 2 3"
  exit
end


trig_pin = ARGV[0].to_i
echo_pin = ARGV[1].to_i

pulse_start = pulse_end = 0

# io = WiringPi::GPIO.new(WPI_MODE_GPIO)

trig_pin = PiPiper::Pin.new(:pin => trig_pin, :direction => :out)
echo_pin = PiPiper::Pin.new(:pin => echo_pin, :direction => :in)



puts "Distance Measurement In Progress"

# give sensor a chance to chill out
trig_pin.off
sleep(2)

# arm sensor by turning trigger on for 10 micro seconds
trig_pin.on
sleep(0.00001)
trig_pin.off

echo_pin.read
while echo_pin.off? { echo_pin.read }
pulse_start = Time.now

echo_pin.read
while echo_pin.on? do
 pulse_end = Time.now
 echo_pin.read
end

puts "pulse_end: #{pulse_end}"
puts "pulse_start: #{pulse_start}"
pulse_duration = pulse_end - pulse_start
distance = pulse_duration * 17150
distance = distance.to_i
puts "Distance: #{distance} cm." 

