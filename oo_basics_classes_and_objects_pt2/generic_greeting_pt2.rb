#Using the following code, add two methods:
#::generic_greeting (class method that prints a greeting that's generic to the class)
#..and...
# #personal_greeting (instance method that prints a greeting custom to the object)


class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def personal_greeting
    puts "Hello from the specific cat #{name}!"
  end

  def self.generic_greeting
    puts "Hello from the cat class!"
  end
end

kitty = Cat.new('Sophie')

Cat.generic_greeting
kitty.personal_greeting