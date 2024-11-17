#Now that we have a Walkable module from moving.rb, we need a new challenge.
#Some of our users are nobility, and the regular way of walking simply isn't good enough.
#Nobility need to strut.

#We need a new class `Noble` that shows the title and name when `walk` is called.

# byron = Noble.new("Byron", "Lord")
# byron.walk
# # => "Lord Byron struts forward"

# byron.name
# => "Byron"
# byron.title
# => "Lord"

module Walkable
  def walk
    "#{self} #{gait} forward"
  end
end

class Noble
  attr_reader :name, :title

  include Walkable

  def initialize(name, title)
    @name = name
    @title = title
  end

  def to_s
    "#{title} #{name}"
  end

  private

  def gait
    "struts"
  end
end

class Person
  include Walkable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    name
  end

  private

  def gait
    "strolls"
  end
end

class Cat
  include Walkable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    name
  end

  private

  def gait
    "saunters"
  end
end

class Cheetah
  include Walkable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    name
  end

  private

  def gait
    "runs"
  end
end

byron = Noble.new("Byron", "Lord")
p byron.walk
# => "Lord Byron struts forward"

p byron.name
p byron.title

mike = Person.new("Mike")
p mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
p kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
p flash.walk
# => "Flash runs forward"

