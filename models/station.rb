class Station
  state_machine :state, :initial => :preboot do
    before_transition :parked => any - :parked, :do => :put_on_seatbelt
    event(:reboot) { transition all => :booting }
  end

  def initialize(pins)
    @pins = pins
    initialize_gpio
    initialize_sensors
    reset_sensors
    puts "all set!"
  end

  def begin

  end

  private
  
  def initialize_gpio
    @wiring_io = WiringPi::GPIO.new(WPI_MODE_GPIO)
  end

  def initialize_sensors
    puts "initializing sensors..."
    @all_sensors = []
    initialize_entry_sensor
    initialize_exit_sensor
    initialize_beam_sensors
  end

  def initialize_beam_sensors
    @beam_sensors = []
    @pins[:beam_sensors].each do |pins|
      sensor = Sensor.new(pins[:trigger], pins[:echo], @wiring_io)
      @beam_sensors << sensor
      @all_sensors << sensor
    end
  end

  def initialize_entry_sensor
    entry_sensor = @pins[:entry_sensor]
    @entry_sensor = Sensor.new(entry_sensor[:trigger], entry_sensor[:echo], @wiring_io)
    @all_sensors << @entry_sensor
  end

  def initialize_exit_sensor
    exit_sensor = @pins[:exit_sensor]
    @exit_sensor = Sensor.new(exit_sensor[:trigger], exit_sensor[:echo], @wiring_io)
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
