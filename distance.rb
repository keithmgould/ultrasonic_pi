require 'wiringpi'

TRIG = 23
ECHO = 24
pulse_sart = pulse_end = 0

io = WiringPi::GPIO.new(WPI_MODE_GPIO)

io.mode(TRIG,OUTPUT)
io.mode(ECHO,INPUT)


puts "Distance Measurement In Progress"

# give sensor a chance to chill out
io.write(TRIG,0)
sleep(2)

# arm sensor by turning TRIG on for 10 micro seconds
io.write(TRIG,1)
sleep(0.00001)
io.write(TRIG,0)


while io.read(ECHO) == 0 do
 pulse_start = Time.now
end

while io.read(ECHO) == 1 do
 pulse_end = Time.now
end

puts "pulse_end: #{pulse_end}"
puts "pulse_start: #{pulse_start}"
pulse_duration = pulse_end - pulse_start
distance = pulse_duration * 17150
distance = distance.to_i
puts "Distance: #{distance} cm." 

