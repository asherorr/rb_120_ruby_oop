#Write a class that will display:

# ABC
# xyz

#When the following code is run:
class Transform
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def uppercase
    data.upcase
  end
  
  def self.lowercase(str)
    str.downcase
  end

end


my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')

