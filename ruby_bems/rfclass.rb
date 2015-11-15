#!/usr/bin/env ruby

print "__FILE__ = ", __FILE__, "\n";

class MegaGreeter
	attr_accessor:names
	#Initialize the object
	def initialize(names = "World")
		@names = names
	end

	#Greet based on 'names' values
	def say_hi
		if @names.nil?
			puts "..."
		elsif @names.respond_to?("each")
		      	#if @names is a list then iterate
			@names.each do |name|
			  puts "Hello #{name}"
		        end
		else
			puts "Hello #{@names}"
		end
	end
	#Greet based on 'names' values
	def say_bye
		if @names.nil?
			puts "..."
		elsif @names.respond_to?("join")
			#Join the list elements with commas
			puts "Goodbye #{@names.join(', ')}. Comeback soon!"
		else
			puts "Good bye #{@names}. Comeback soon!"
		end
	end
end

if __FILE__ == $0
	mg = MegaGreeter.new
	mg.say_hi
	mg.say_bye

	#Change name to Cliqr
	mg.names = "Cliqr"
	mg.say_hi
	mg.say_bye

	#Change name to an array of names
	mg.names = [ 'Bhaskar', 'Chandana', 'Dilip', 'Prasad', 'Suresh' ];
	mg.say_hi
	mg.say_bye

	#Change name to null
	mg.names = nil
	mg.say_hi
	mg.say_bye
end	

