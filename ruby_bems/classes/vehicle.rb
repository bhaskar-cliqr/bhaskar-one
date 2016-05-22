
module Towable
  def can_tow(_pounds)
    pounts < 2000 ? true : false
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :model, :year

  @@vehicle_count = 0

  def initialize(year, model, color)
    @year = year
    @model = model
    @color = color
    @current_speed = 0
    @@vehicle_count += 1
  end

  def speed_up(number)
    @current_speed += number
  end

  def brake(number)
    @current_speed -= number
  end

  def current_speed
    puts "Your speed now is #{@current_speed}/mph"
  end

  def shut_down
    puts 'Your car is now stopped'
  end

  def spray_paint(color)
    self.color = color
    puts "Your new #{self.color} paint job looks great."
  end

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end

  def self.vehicle_count
    puts "Total vehicles are: #{@@vehicle_count}"
  end

  def age
	  "Your #{self.model} is #{year_old} years old"
  end

  private

  def year_old
	  Time.now.year - self.year
  end

end

class MyCar < Vehicle
  include Towable
  DOOR_COUNT = 4

  def to_s
    "My car is a #{color}, #{year}, #{model}!"
  end
end

class Truck < Vehicle
  include Towable
  DOOR_COUNT = 2

  def to_s
    "My truck  is a #{color}, #{year}, #{model}!"
  end
end

Vehicle.vehicle_count
mycar_obj = MyCar.new(1997, 'chevy lumina', 'white')
truck_obj = Truck.new(1998, 'tata tipper', 'yellow')

Vehicle.vehicle_count

puts '********** MyCar ancestors **********'
puts MyCar.ancestors
puts '********** Truck ancestors **********'
puts Truck.ancestors
puts '********** Vehicle ancestors **********'
puts Vehicle.ancestors

lumina = MyCar.new(1997, 'chevy lumina', 'white')
lumina.speed_up(20)
lumina.current_speed
lumina.speed_up(20)
lumina.current_speed
lumina.brake(20)
lumina.current_speed
lumina.brake(20)
lumina.current_speed
lumina.shut_down
MyCar.gas_mileage(13, 351)
lumina.spray_paint('red')
puts lumina

puts lumina.age


