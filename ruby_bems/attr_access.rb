#Accessing undefined method
class Person
end

#only reader method
class Person1
    def name
        @name
    end
end


#reader and writer methods
class Person2
    def name
        @name
    end
    
    def name=(str)
        @name = str
    end
end

#short-cut to Person2
class Person3
    attr_reader :name
    attr_writer :name
end

#Short-cut to Person3
class Person4
    attr_accessor :name
end

person = Person.new
#attr_access.rb:5:in `<main>': undefined method `name' for #<Person:0x000000026f5480> (NoMethodError)
#person.name; #above error

person1 = Person1.new
puts "person1.name: " + person1.name.to_s
#person1.name: 
#attr_access.rb:17:in `<main>': undefined method `name=' for #<Person1:0x00000001fb6ac0> (NoMethodError)
#person1.name = "Bhaskar" #above error

person2 = Person2.new
person2.name = "Bhaskar"
puts "person2.name: " + person2.name

person3 = Person3.new
person3.name = "Bhaskar"
#person1.name: 
#person2.name: Bhaskar
#person3.name: Bhaskar
puts "person3.name: " + person3.name

person4 = Person4.new
person4.name = "Bhaskar"
#person1.name: 
#person2.name: Bhaskar
#person3.name: Bhaskar
#person4.name: Bhaskar
puts "person4.name: " + person4.name

