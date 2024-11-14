#Correct the program so that it works properly.
#Assume that the customer and employee classes have complete implementations;
#Just make the smallest possible change to ensure that objects of both types have access
#to the `print_address` method.

# module Mailable
#   def print_address
#     puts "#{name}"
#     puts "#{address}"
#     puts "#{city}, #{state} #{zipcode}"
#   end
# end

# class Customer
#   attr_reader :name, :address, :city, :state, :zipcode
# end

# class Employee
#   attr_reader :name, :address, :city, :state, :zipcode
# end

# betty = Customer.new 
# bob = Employee.new
# betty.print_address
# bob.print_address

module Mailable
  def print_address
    puts "#{name}"
    puts "#{address}"
    puts "#{city}, #{state} #{zipcode}"
  end
end

class Customer
  include Mailable
  
  attr_reader :name, :address, :city, :state, :zipcode
end

class Employee
  include Mailable
  
  attr_reader :name, :address, :city, :state, :zipcode
end

betty = Customer.new 
bob = Employee.new
betty.print_address
bob.print_address