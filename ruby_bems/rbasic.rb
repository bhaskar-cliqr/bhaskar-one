
#require 'Math'

### Basic
puts "Plain - Hello World"

##Calcs
print "3+2  = ",3+2,"\n"
print "3*2  = ",3*2,"\n"
print "3**2 = ",3**2,"\n"

#Subroutine without params
def h
	puts "API without args: Hello World"
end
h

#Subroutine with one param, name.
def hname(name)
	puts "API with name arg: Hello #{name}!"
end

hname("Bhaskar");
name = 'Bhaskar';
hname( name);
hname "CliqrTech";

#Subroutine with one param, name with Default value.
def hnamedf( name = "World!")
	puts "API with arg and default: Hello #{name}!"
end
hnamedf( name);
hnamedf();


##Class Definition
class Greeter
	def initialize( name = "World!")
		puts "Class Greeter: initialize"
		@name = name
	end
	def say_hi
		puts "Hi #{@name}!"
	end
	def say_bye
		puts "Bye #{@name}!"
	end
end #End of Class-Def

g = Greeter.new()
g.say_hi
g.say_bye
gn = Greeter.new("Bhaskar")
gn.say_hi
gn.say_bye
Greeter.instance_methods()
gn.respond_to?("name")
gn.respond_to?("say_hi")
gn.respond_to?("to_s")

puts

class Greeter
	attr_accessor :name
end
g = Greeter.new("Zulfi")
g.say_hi
g.say_bye
g.name = "Bhaskar"
print "g.name = ", g.name, "\n"
g.say_hi
g.say_bye
