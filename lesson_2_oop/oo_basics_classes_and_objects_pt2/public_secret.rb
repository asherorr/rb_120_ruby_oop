#Using the following code, create a class named `Person`
#With an instance variable named @secret.
#Use a setter method to add a value to @secret
#Then use a getter method to print @secret 

class Person
  attr_accessor :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
puts person1.secret
