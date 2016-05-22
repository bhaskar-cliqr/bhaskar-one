class GoodDog2
	  ## @name is instance variable ##
	  def initialize(name)
		@name = name
	  end

	  def speak
		  puts "#{@name} says bow-bow!"
	  end

	  ## Getter method ##
	  def get_name
		  @name
	  end

	  ## Setter method ##
	  def set_name=(name)
		  @name = name
	  end

	  ## Getter/Setter to use same name as instance variables ##
	  def name
		  @name
	  end

	  def name=(n)
		  @name = n
	  end
end

sparky = GoodDog2.new('Sparky')
sparky.speak
fido   = GoodDog2.new('Fido')
fido.speak

sparky.speak
puts sparky.get_name

sparky.set_name = 'Spartan'
sparky.speak
puts sparky.get_name

sparky.name = 'Bittu'
sparky.speak
puts sparky.get_name
puts sparky.name



