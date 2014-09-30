class Station

  BOX_DISTANCE = 10 # Max distance in cm when considering if a box is present
  BEAM_DISTANCE = 40 # Max distance in cm when considering if the beam is broken

  REST_TIME = 0.025 # seconds inbetween each sensor

  SENSOR_MAX_AVG = 3

  # Bit positions for determining state.  See Valid Transisions below for more details
  ENTRY_SENSOR  = 0
  INSIDE_SENSOR = 1
  EXIT_SENSOR   = 2
  BEAM          = 3

  # Each state is determined by looking at the integer representation of the 4 bits shown above.
  # So if the entry sensor is on, and the beam has been broken, that would be 1001 or '9'
  VALID_TRANSITIONS = [
    # 0 => entry off, inside off, exit off, beam off
    { valid: [8], invalid_entry: [], invalid_exit: [2,3,6,7], missed_ingredient: [] },

    # 1 => entry off, inside off, exit off, beam on
    { valid: [], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 2 => entry off, inside off, exit on, beam off
    { valid: [6,3], invalid_entry: [8,9,12,13], invalid_exit: [], missed_ingredient: [0] },

    # 3 => entry off, inside off, exit on, beam on
    { valid: [7,0], invalid_entry: [8,9,12,13], invalid_exit: [], missed_ingredient: [] },

    # 4 => entry off, inside on, exit off, beam off
    { valid: [12,6,5], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 5 => entry off, inside on, exit off, beam on
    { valid: [13,7], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 6 => entry off, inside on, exit on, beam off
    { valid: [4,2,7], invalid_entry: [8,9,12,13], invalid_exit: [], missed_ingredient: [] },

    # 7 => entry off, inside on, exit on, beam on
    { valid: [5,3], invalid_entry: [8,9,12,13], invalid_exit: [], missed_ingredient: [] },

    # 8 => entry on, inside off, exit off, beam off
    { valid: [0,12,9], invalid_entry: [], invalid_exit: [2,3,6,7], missed_ingredient: [] },

    # 9 => entry on, inside off, exit off, beam on
    { valid: [13], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 10 => entry on, inside off, exit on, beam off
    { valid: [], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 11 => entry on, inside off, exit on, beam on
    { valid: [], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 12 => entry on, inside on, exit off, beam off
    { valid: [8,4], invalid_entry: [], invalid_exit: [2,3,6,7], missed_ingredient: [] },

    # 13 => entry on, inside on, exit off, beam on
    { valid: [9,5], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 14 => entry on, inside on, exit on, beam off
    { valid: [], invalid_entry: [], invalid_exit: [], missed_ingredient: [] },

    # 15 => entry on, inside on, exit on, beam on
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
      check_box
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
    @entry_sensor_avg >= SENSOR_MAX_AVG ? 1 : 0
  end

  def inside_on?
    @inside_sensor_avg >= SENSOR_MAX_AVG ? 1 : 0
  end

  def exit_on?
    @exit_sensor_avg >= SENSOR_MAX_AVG ? 1 : 0
  end

  def check_box
    @entry_sensor_avg += @entry_sensor.distance <= BOX_DISTANCE ? 1 : -1
    @entry_sensor_avg = 0 if @entry_sensor_avg < 0
    @entry_sensor_avg = 0 if @entry_sensor_avg < 0
    sleep(REST_TIME)

    @inside_sensor_avg += @inside_sensor.distance <= BOX_DISTANCE ? 1 : -1
    @inside_sensor_avg = 0 if @inside_sensor_avg < 0
    @inside_sensor_avg = 0 if @inside_sensor_avg < 0
    sleep(REST_TIME)

    @exit_sensor_avg += @exit_sensor.distance <= BOX_DISTANCE ? 1 : -1
    @exit_sensor_avg = 0 if @exit_sensor_avg < 0
    @exit_sensor_avg = 0 if @exit_sensor_avg < 0
    sleep(REST_TIME)
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
    @entry_sensor_avg = 0
    @inside_sensor_avg = 0
    @exit_sensor_avg = 0
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
