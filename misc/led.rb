require 'pi_piper'

# Wire the 3.3v to the anode (longer pin) of the LED
# Wire the GPIO to the cathode (shorter pin) of the LED

unless ARGV.size == 1
  puts "please enter the GPIO Pin to use when running this script"
  puts "ex: ruby led.rb 23"
  exit
end

pin = ARGV[0].to_i

led = PiPiper::Pin.new(:pin => pin, :direction => :out)

loop do
 sleep(0.5)
 led.on
 sleep(0.5)
 led.off
end
