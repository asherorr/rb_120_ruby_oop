#Take a look at the following code

class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    "My name is #{@name}."
  end
end

name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name
puts fluffy
puts fluffy.name
puts name

#What is output by this code? Think about any undesirable effects occuring due
#to the invocation on line 17.
#Fix this class so there are no surprises waiting in store for unsuspecting developers.

