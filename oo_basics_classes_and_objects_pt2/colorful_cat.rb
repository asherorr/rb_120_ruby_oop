#Using the following code, create a class named `Cat` that prints a greeting when #greet is invoked.
#The greeting should include the name and color of the cat.
#Use a constant to define the color.

class Cat
  COLOR = "white"

  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def greet
    puts "Hello from #{name}, a #{COLOR} cat!"
  end
end

kitty = Cat.new('Sophie')
kitty.greet