# Example of a method that modifies its argument permanently
# mutate.rb

a = [1, 2, 3]

def mutate(array)
  array.pop
end

def no_mutate(array)
  array.last
end

p "Before mutate method: #{a}"
mutate(a)
p "After mutate method: #{a}"
no_mutate(a)
p "After no_mutate method: #{a}"
mutate(a.clone)
p "After mutate method with clone: #{a}"


puts x = 2
p name = "Joe"
print something = "nothing"



