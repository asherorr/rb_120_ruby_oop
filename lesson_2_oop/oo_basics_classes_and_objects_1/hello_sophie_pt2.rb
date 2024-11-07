#Using the code from the previous exercise (hello_sophie_pt1.rb), move the greeting from the #initialize method to an instance method
#Named #greet that prints a greeting when invoked.

class Cat
  def initialize(name)
    @name = name
  end

  def greet
    puts"Hello! My name is #{@name}!"
  end
end

kitty = Cat.new("Sophie")
kitty.greet