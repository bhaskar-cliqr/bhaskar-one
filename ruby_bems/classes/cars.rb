
class Cars
  attr_accessor :name, :year, :color, :model, :speed
  attr_writer :new_color
  attr_reader :show_year

  def initialize(name, year, color, model)
    self.name = name
    self.year = year
    self.color = color
    self.model = model
    self.speed = 0
  end

  def speed_up(new_speed = 5)
    puts ">>>>>>>> Increasing speed by #{new_speed}".upcase
    self.speed += new_speed
    puts "#{name} speed is now #{self.speed}/kmph"
  end

  def break(new_speed = 5)
    puts "<<<<<<<< Decreasing speed by #{new_speed}".upcase
    self.speed -= new_speed
    puts "#{name} speed is #{self.speed}/kmph"
  end

  def shutoff
    puts '======== Shutting off the car'.upcase
    self.speed = 0
  end

  def show
    puts '-:*********    Car Data  *********:-'
    puts "Name : #{name}"
    puts "Year : #{year}"
    puts "Color: #{color}"
    puts "Model: #{model}"
    puts "Speed: #{self.speed}"
    puts '-:********************************:-'
  end

  def new_color=(color)
    self.color = color
  end

  def car_year
	puts "Car was made in Year #{self.year}"
  end

  def spray_paint(color)
	  self.color = color
	  puts "You new #{self.color} paint job looks great!"
  end
end

ford = Cars.new('Ford', '2015', 'Mars Red', 'Hatchback')
ford.show
ford.speed_up
ford.speed_up(12)
ford.break
ford.break(10)
ford.shutoff
ford.color = 'Black'
ford.car_year
ford.show
#ford.car_year = '2011'
ford.spray_paint('Maroon')
ford.show
