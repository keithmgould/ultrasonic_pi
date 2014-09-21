require 'wiringpi'

unless ARGV.size == 2
  puts "Please enter trigger and echo pins."
  puts "ex: ruby distance.rb 2 3"
  exit
end


trigger = ARGV[0].to_i
echo = ARGV[1].to_i

pulse_start = pulse_end = 0

io = WiringPi::GPIO.new(WPI_MODE_GPIO)

io.mode(trigger,OUTPUT)
io.mode(echo,INPUT)


puts "Distance Measurement In Progress"

# give sensor a chance to chill out
io.write(trigger,0)
sleep(2)

# arm sensor by turning trigger on for 10 micro seconds
io.write(trigger,1)
sleep(0.00001)
io.write(trigger,0)


while io.read(echo) == 0 do
 pulse_start = Time.now
end

while io.read(echo) == 1 do
 pulse_end = Time.now
end

puts "pulse_end: #{pulse_end}"
puts "pulse_start: #{pulse_start}"
pulse_duration = pulse_end - pulse_start
distance = pulse_duration * 17150
distance = distance.to_i
puts "Distance: #{distance} cm." 

