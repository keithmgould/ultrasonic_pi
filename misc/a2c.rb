require 'pi_piper'

class Beam
  def self.broken?
    broken = false
    puts "*" * 20
    8.times do |i|
      value = 0
      PiPiper::Spi.begin do |spi|
        raw = spi.write [1, (8+i)<<4, 0]
        value = ((raw[1]&3) << 8) + raw[2]
      end

      invert = 1023 - value
      mvolts = invert * (3300.0 / 1023.0)
      # print "#{i}: #{mvolts}"
      if mvolts < 300
        broken = true
        puts "BEAM #{i} BROKEN! ( #{mvolts} )"
      end
    end
  end
end

loop do
 Beam.broken?
 sleep(0.25)
end
