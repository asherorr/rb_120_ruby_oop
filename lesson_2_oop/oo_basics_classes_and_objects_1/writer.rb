#Using the code from reader.rb, add a setter method named `#name=`. Then, rename `kitty` to `Luna` and invoke #greet
#again.

#Code
class Cat

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def greet
    puts"Hello! My name is #{name}!"
  end

  def name=(name)
    @name = name
  end
end

kitty = Cat.new("Sophie")
kitty.greet
kitty.name= "Luna"
kitty.greet