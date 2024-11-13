#Consider the following class definition:

class Flight
  attr_accessor :database_handle

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end

#There is technically nothing incorrect about this class, but the definition may lead to problems in the future.
#How can this class be fixed to be resistant to future problems?

#We want to delete the attr_accessor method. 
#By making access to `@database_handle` easy, someone may use it in real code.
#Once the database handle is being used in real code, future modifications to the class may break the code.