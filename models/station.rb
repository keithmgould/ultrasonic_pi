class Station

  BOX_DISTANCE = 10 # Max distance in cm when considering if a box is present
  BEAM_DISTANCE = 40 # Max distance in cm when considering if the beam is broken

  REST_TIME = 0.025 # seconds inbetween each sensor

  # how far back to go when looking at rolling avg
  SENSOR_HISTORY_LENGTH = 3

  def initialize(pins)
    @pins = pins
    initialize_gpio
    initialize_sensors
    reset_sensors
    reset_state
    puts "all set!"
  end

  def begin
    puts "beginning!"
    loop do
      check_beam_sensors
      check_box_sensors
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

  def perform_state_actions
    case @state
    when 0
      reset_state
    end
  end

  def valid_transition?(new_state)
    VALID_TRANSITIONS[@state][:valid].include?(new_state)
  end

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
    @beam_sensors.each do |sensor|
      distance = sensor.distance
      @beam_broken = 1 if distance < 40
      sleep(REST_TIME)
    end 
  end

  #-----------------------------------------------------
  # Methods Below Concern Initialization
  
  def initialize_gpio
    @wiring_io = WiringPi::GPIO.new(WPI_MODE_GPIO)
  end

  def initialize_sensors
    puts "initializing sensors..."
    @all_sensors = []
    initialize_beam_sensors
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
    sensor = Sensor.new(pins[:trigger], pins[:echo], @wiring_io, sensor_name.to_s)
    @all_sensors << sensor
    @box_sensors[sensor_name] = sensor
  end

  def initialize_beam_sensors
    @beam_sensors = []
    @pins[:beam_sensors].each_with_index do |pins, index|
      sensor = Sensor.new(pins[:trigger], pins[:echo], @wiring_io, "beam_#{index + 1}")
      @beam_sensors << sensor
      @all_sensors << sensor
    end
  end

  def reset_sensors
    puts "resetting sensors..."
    @all_sensors.each do |sensor|
      sensor.reset 
    end
    sleep(2)
  end

  def reset_state
    puts "resetting state..."
    @state = 0
    @beam_broken = 0
    [:entry_sensor, :inside_sensor, :exit_sensor].each do |sensor_name|
      @box_sensor_history[sensor_name] = []
    end
  end
end
