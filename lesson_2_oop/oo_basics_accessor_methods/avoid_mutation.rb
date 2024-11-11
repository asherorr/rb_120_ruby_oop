#The following code is flawed.
#It currently allows @name to be modified from outside
#The method via a destructive method call.
#Fix the code so that it returns a copy of @name
#Instead of a reference to it.

class Person

  def initialize(name)
    @name = name
  end

  def name
    @name.dup
  end
end

person1 = Person.new('James')
person1.name.reverse!
puts person1.name