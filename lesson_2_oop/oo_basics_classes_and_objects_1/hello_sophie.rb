#Using the code from what_are_you.rb, add a parameter to #initialize that provides a name for the
#Cat object. 
#Use an instance variable to print a greeting with the provided name.

class Cat
  def initialize(name)
    @name = name
    puts "Hello! My name is #{@name}!"
  end
end

kitty = Cat.new("Sophie")
