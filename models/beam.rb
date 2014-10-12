class Beam
  def self.broken?
    broken = false
    8.times do |i|
      value = 0
      PiPiper::Spi.begin do |spi|
        raw = spi.write [1, (8+i)<<4, 0]
        value = ((raw[1]&3) << 8) + raw[2]
      end

      invert = 1023 - value
      mvolts = invert * (3300.0 / 1023.0)
      if mvolts < 300
        broken = true
      end
      sleep(0.005)
    end
    broken
  end
end
