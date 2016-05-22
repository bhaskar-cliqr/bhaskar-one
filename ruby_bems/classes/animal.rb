
## Animal class - Base
class Animal
	attr_accessor :name

	def initialize(name)
		self.name = name
	end

	def speak
		'Hello!'
	end

	def speak2
		'Hi!'
	end
end

## Dog inheriting Animal class 
class Dog < Animal
	attr_accessor :color

	def initialize(name,color='Brown')
		super(name)
		self.color = color
	end

	## Overriding method in Animal class
	def speak
		"#{self.name} say bow-bow!"
	end

	## Use super to call same method from base classes
	def speak2
		super + " from Dog class"
	end
end

class Cat < Animal
end


spartan = Dog.new('Spartan')
paws    = Cat.new('Paws')

#Ruby checks the object's class first for the method before it looks in the superclass
puts spartan.speak
puts paws.speak

#"DRY". This stands for "Don't Repeat Yourself".
puts spartan.speak2

