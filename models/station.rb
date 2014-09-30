class Station

  BOX_DISTANCE = 10 # Max distance in cm when considering if a box is present
  BEAM_DISTANCE = 40 # Max distance in cm when considering if the beam is broken

  REST_TIME = 0.025 # seconds inbetween each sensor

  # Bit positions for determining state.  See Valid Transisions below for more details
  ENTRY_SENSOR  = 0
  INSIDE_SENSOR = 1
  EXIT_SENSOR   = 2
  BEAM          = 3 

  # Each state is determined by looking at the integer representation of the 4 bits shown above.
  # So if the entry sensor is on, and the beam has been broken, that would be 1001 or '9'
  VALID_TRANSITIONS = [
    { valid: [8], invalid_entry: [], invalid_exit: [2,3,6,7], missed_ingredient: [] },
    { valid: [], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },
    { valid: [6,3], invalid_entry: [8,9,12,13], invalid_exit: [], missed_ingredient: [0] },
    { valid: [7,0], invalid_entry: [8,9,12,13], invalid_exit: [], missed_ingredient: [] },
    { valid: [12,6], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },
    { valid: [13,7], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },
    { valid: [4,2], invalid_entry: [8,9,12,13], invalid_exit: [], missed_ingredient: [] },
    { valid: [5,3], invalid_entry: [8,9,12,13], invalid_exit: [], missed_ingredient: [] },
    { valid: [0,12,9], invalid_entry: [], invalid_exit: [2,3,6,7], missed_ingredient: [] },
    { valid: [13], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },
    { valid: [], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },
    { valid: [], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },
    { valid: [8,4], invalid_entry: [], invalid_exit: [2,3,6,7], missed_ingredient: [] },
    { valid: [9,5], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },
    { valid: [], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },
    { valid: [], invalid_entry: [], invalid_exit: [], missed_ingredient: [] }
  ]


  def initialize(pins)
    @pins = pins
    initialize_state
    initialize_gpio
    initialize_sensors
    reset_sensors
    puts "all set!"
  end

  def begin
    puts "beginning!"
    loop do
      check_beam unless @beam_broken
      transition
    end
  end

  private

  def transition
    new_state = fetch_sensor_state
    return if new_state == @state
    puts "Transitioning from #{@state} to #{new_state}"
    if valid_transition?(new_state)
      # do nothing :) 
    else
      puts "Invalid transition!"
      # TODO: toss up the correct error light
    end
    @state = new_state
  end 

  def valid_transition?(new_state)
    VALID_TRANSITIONS[@state][:valid].include?(new_state)
  end

  def fetch_sensor_state
    "#{entry_on?}#{inside_on?}#{exit_on?}#{@beam_broken}".to_i(2)
  end

  def entry_on?
    sleep(REST_TIME)
    @entry_sensor.distance <= BOX_DISTANCE ? 1 : 0
  end

  def inside_on?
    sleep(REST_TIME)
    @inside_sensor.distance <= BOX_DISTANCE ? 1 : 0
  end

  def exit_on?
    sleep(REST_TIME)
    @exit_sensor.distance <= BOX_DISTANCE ? 1 : 0
  end

  def check_beam
    points = 0
    2.times do
      @beam_sensors.each do |sensor|
        distance = sensor.distance
        points += 1 if distance < 40
        sleep(REST_TIME)
      end 
    end
    @beam_broken = points > 4 ? 1 : 0
    puts "beam broken: #{@beam_broken}"
  end

  #-----------------------------------------------------
  # Methods Below Concern Initialization

  def initialize_state
    @beam_broken = false
    @state = 0
    # TODO turn error lights off
    # TODO turn status light to blinking on
  end
  
  def initialize_gpio
    @wiring_io = WiringPi::GPIO.new(WPI_MODE_GPIO)
  end

  def initialize_sensors
    puts "initializing sensors..."
    @all_sensors = []
    initialize_entry_sensor
    initialize_inside_sensor
    initialize_exit_sensor
    initialize_beam_sensors
  end

  def initialize_beam_sensors
    @beam_sensors = []
    @pins[:beam_sensors].each_with_index do |pins, index|
      sensor = Sensor.new(pins[:trigger], pins[:echo], @wiring_io, "beam_#{index + 1}")
      @beam_sensors << sensor
      @all_sensors << sensor
    end
  end

  def initialize_entry_sensor
    entry_sensor = @pins[:entry_sensor]
    @entry_sensor = Sensor.new(entry_sensor[:trigger], entry_sensor[:echo], @wiring_io, 'entry_sensor')
    @all_sensors << @entry_sensor
  end

  def initialize_inside_sensor
    inside_sensor = @pins[:inside_sensor]
    @inside_sensor = Sensor.new(inside_sensor[:trigger], inside_sensor[:echo], @wiring_io, 'inside_sensor')
    @all_sensors << @inside_sensor
  end

  def initialize_exit_sensor
    exit_sensor = @pins[:exit_sensor]
    @exit_sensor = Sensor.new(exit_sensor[:trigger], exit_sensor[:echo], @wiring_io, 'exit_sensor')
    @all_sensors << @exit_sensor
  end

  def reset_sensors
    puts "resetting sensors..."
    @all_sensors.each do |sensor|
      sensor.reset 
    end
    sleep(2)
  end
end
