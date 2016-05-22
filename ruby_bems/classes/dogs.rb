

class Dog
  attr_accessor :name, :age

  # #Constant
  Dogyears = 7

  # #Class variable
  @@number_of_dogs = 0
  def initialize(n = 'Sparky', a = 4)
    @@number_of_dogs += 1
    self.name = n
    self.age  = a * Dogyears
  end

  ## Class method
  def self.total_dogs
    @@number_of_dogs
  end

  def self.what_am_i
    puts "I'm a Dog class!"
  end

  def to_s
    "This dog's name is #{name} and it's age is #{age}"
  end
end
Dog.what_am_i
puts Dog.total_dogs
dog1 = Dog.new
dog2 = Dog.new('Bittoo', 3)
puts Dog.total_dogs

puts dog1.age
puts dog2
p dog1
