#Modify the following code to accept
#a string containing a first and last name
#The name should be split into two instance variables
#In the setter method, then joined in the getter method to form a full name.

class Person
  def name=(full_name)
    @first_name, @last_name = full_name.split(" ")
  end

  def name
    "#{@first_name} #{@last_name}"
  end
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name