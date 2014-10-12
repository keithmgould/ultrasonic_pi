class Station

  # Max distance in cm when considering if a box is present
  BOX_DISTANCE = 10

  # seconds inbetween each box sensor
  REST_TIME = 0.025

  # how far back to go when looking at rolling avg
  SENSOR_HISTORY_LENGTH = 3

  def initialize(pins)
    @pins = pins
    initialize_leds
    initialize_gpio
    initialize_sensors
    initialize_reset_button
    reset_sensors
    reset_state
    puts "all set!"
  end

  def begin
    puts "beginning!"
    loop do
      check_reset_button
      check_beam_sensors
      check_box_sensors
      transition
    end
  end

  private

  #-----------------------------------------------------------------------
  # Methods Below Concern State Transition
  #-----------------------------------------------------------------------

  def transition
    new_state = fetch_sensor_state
    return if new_state == @state
    puts "Transitioned from #{@state} to #{new_state}"
    if valid_transition?(new_state)
      @state = new_state
      # Do nothing
    else
      puts "Invalid transition!"
      @beam_broken = 0
      # TODO: toss up the correct error light
    end
  end

  # Valida Transitions found in config/transitions
  def valid_transition?(new_state)
    VALID_TRANSITIONS[@state][:valid].include?(new_state)
  end

  #-----------------------------------------------------------------------
  # Methods Below Concern Sensor State
  #-----------------------------------------------------------------------

  def fetch_sensor_state
    "#{entry_on}#{inside_on}#{exit_on}#{@beam_broken}".to_i(2)
  end

  def entry_on
    @box_sensor_history[:entry_sensor].mean >= 0.5 ? 1 : 0
  end

  def inside_on
    @box_sensor_history[:inside_sensor].mean >= 0.5 ? 1 : 0
  end

  def exit_on
    @box_sensor_history[:exit_sensor].mean >= 0.5 ? 1 : 0
  end

  def check_reset_button
    @reset_button.read
    if @reset_button.off? 
      reset_state
    end
  end

  def check_box_sensors
    [:entry_sensor, :inside_sensor, :exit_sensor].each do |sensor_name|
     result = @box_sensors[sensor_name].distance <= BOX_DISTANCE ? 1 : 0
     @box_sensor_history[sensor_name].push(result)
     @box_sensor_history[sensor_name].shift if  @box_sensor_history[sensor_name].length > SENSOR_HISTORY_LENGTH
     sleep(REST_TIME)
    end
  end

  def check_beam_sensors
    return if @beam_broken == 1
    @beam_broken = Beam.broken? ? 1 : 0
    puts "Beam Broken!" if @beam_broken == 1
  end

  #-----------------------------------------------------------------------
  # Methods Below Concern Signalling with LEDs
  #-----------------------------------------------------------------------

  def turn_on_leds
    @entry_led.on
    @exit_led.on 
  end

  def turn_off_leds
    @entry_led.off
    @exit_led.off
  end

  #-----------------------------------------------------------------------
  # Methods Below Concern Initialization
  #-----------------------------------------------------------------------

  def initialize_leds
    @entry_led = PiPiper::Pin.new(:pin => @pins[:entry_error], :direction => :out) 
    @exit_led = PiPiper::Pin.new(:pin => @pins[:exit_error], :direction => :out) 
    turn_on_leds
  end

  def initialize_gpio
    # TODO: does pi piper need anything here?
    # @wiring_io = WiringPi::GPIO.new(WPI_MODE_GPIO)
  end

  def initialize_reset_button
    @reset_button = PiPiper::Pin.new(:pin => @pins[:reset], :direction => :in)
  end

  def initialize_sensors
    puts "initializing sensors..."
    initialize_box_sensors
  end

  def initialize_box_sensors
    @box_sensors = {}
    @box_sensor_history = {}
    [:entry_sensor, :inside_sensor, :exit_sensor].each do |sensor_name|
      @box_sensor_history[sensor_name] = []
      initialize_box_sensor(sensor_name)
    end
  end

  def initialize_box_sensor(sensor_name)
    pins = @pins[sensor_name]
    sensor = BoxSensor.new(pins[:trigger], pins[:echo], sensor_name.to_s)
    @box_sensors[sensor_name] = sensor
  end

  def reset_sensors
    puts "resetting sensors..."
    [:entry_sensor, :inside_sensor, :exit_sensor].each do |sensor_name|
      @box_sensors[sensor_name].reset
    end
    sleep(2)
  end

  def reset_state
    puts "resetting state..."
    turn_off_leds
    @state = 0
    @beam_broken = 0
    [:entry_sensor, :inside_sensor, :exit_sensor].each do |sensor_name|
      @box_sensor_history[sensor_name] = []
    end
  end
end
