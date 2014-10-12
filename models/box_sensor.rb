class BoxSensor
  attr_reader :name

  MAX_DISTANCE = 60

  def initialize(trig_pin, echo_pin, name = 'none')
    @trig_pin = PiPiper::Pin.new(:pin => trig_pin, :direction => :out)
    @echo_pin = PiPiper::Pin.new(:pin => echo_pin, :direction => :in)
    @name      = name
  end

  # give sensor a chance to chill out
  # make sure to sleep for two seconds after calling
  # this.
  def reset
    @trig_pin.off
  end

  def distance
    # arm sensor by turning @trig_pin on for 10 micro seconds
    @trig_pin.on
    sleep(0.00001)
    @trig_pin.off

    # wait for the echo pin to turn on
    @echo_pin.read
    while @echo_pin.off? { @echo_pin.read }
    pulse_start = Time.now

    # wait for the echo pin to turn off
    @echo_pin.read
    while @echo_pin.on? do
      pulse_end = Time.now
      distance = convert_to_cm(pulse_end - pulse_start)
      break if distance >= MAX_DISTANCE
      @echo_pin.read
    end

    # return how long it took for the echo pin
    # to turn off.  This is your distance in
    # cm.
    distance.to_i
  end

  def convert_to_cm(duration)
    duration * 17150
  end
end
