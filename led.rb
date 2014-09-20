require 'wiringpi'

GPIOPIN = 22

io = WiringPi::GPIO.new(WPI_MODE_GPIO)
io.mode(GPIOPIN, OUTPUT)
io.write(GPIOPIN, 1)

loop do
 sleep(0.5)
 io.write(GPIOPIN, 0)
 sleep(0.5)
 io.write(GPIOPIN, 1)
end

