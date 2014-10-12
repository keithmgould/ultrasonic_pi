# Used to test out a momentary switch with the pi piper library

require "pi_piper"
include PiPiper

unless ARGV.size == 1
  puts "please enter the GPIO Pin to use when running this script"
  puts "ex: ruby switch.rb 23"
  exit
end

pin = ARGV[0].to_i

after :pin => pin, goes: :high do
 puts "Reset button was hit!"
end


loop do
 print '.'
 sleep(0.5)
end
