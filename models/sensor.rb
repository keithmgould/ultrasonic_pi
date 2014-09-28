class Sensor
  attr_reader :name

  def initialize(trig_pin, echo_pin, wiring_io, name = 'none')
    @trig_pin  = trig_pin
    @echo_pin  = echo_pin
    @wiring_io = wiring_io
    @name      = name
    @wiring_io.mode(@trig_pin, OUTPUT)
    @wiring_io.mode(@echo_pin, INPUT)
  end

  # give sensor a chance to chill out
  # make sure to sleep for two seconds after calling
  # this.
  def reset
    @wiring_io.write(@trig_pin, 0)
  end

  def distance
    # arm sensor by turning @trig_pin on for 10 micro seconds
    @wiring_io.write(@trig_pin,1)
    sleep(0.00001)
    @wiring_io.write(@trig_pin,0)

    while @wiring_io.read(@echo_pin) == 0 do
    end
    pulse_start = Time.now

    while @wiring_io.read(@echo_pin) == 1 do
      pulse_end = Time.now
      distance = convert_to_cm(pulse_end - pulse_start)
      break if distance > 60
    end

    distance.to_i
  end

  def convert_to_cm(duration)
    duration * 17150
  end
end
