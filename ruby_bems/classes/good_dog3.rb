class Good_Dog3
	attr_accessor :name
	def initialize(name)
		@name = name
	end

	def speak
		"#{@name} says bow-bow!!"
	end

	def speak2
		"#{name} says bow-bow2!"
	end
end

spartan = Good_Dog3.new('Spartan')
puts spartan.speak
puts spartan.name            # => "Spartan"
spartan.name = "Spartacus"
puts spartan.name            # => "Spartacus"

puts spartan.speak2


