#Consider the following code:

# butterscotch = Pet.new('cat', 'Butterscotch')
# pudding      = Pet.new('cat', 'Pudding')
# darwin       = Pet.new('bearded dragon', 'Darwin')
# kennedy      = Pet.new('dog', 'Kennedy')
# sweetie      = Pet.new('parakeet', 'Sweetie Pie')
# molly        = Pet.new('dog', 'Molly')
# chester      = Pet.new('fish', 'Chester')

# phanson = Owner.new('P Hanson')
# bholmes = Owner.new('B Holmes')

# shelter = Shelter.new
# shelter.adopt(phanson, butterscotch)
# shelter.adopt(phanson, pudding)
# shelter.adopt(phanson, darwin)
# shelter.adopt(bholmes, kennedy)
# shelter.adopt(bholmes, sweetie)
# shelter.adopt(bholmes, molly)
# shelter.adopt(bholmes, chester)
# shelter.print_adoptions
# puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
# puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."

#Write the classes and methods that will be neccesary to make this code run
#and print the following output

# The Animal Shelter has the following unadopted pets:
# a dog named Asta
# a dog named Laddie
# a cat named Fluffy
# a cat named Kat
# a cat named Ben
# a parakeet named Chatterbox
# a parakeet named Bluebell
#    ...

# P Hanson has 3 adopted pets.
# B Holmes has 4 adopted pets.
# The Animal shelter has 7 unadopted pets.
# #---#

#Pet class
  #initialize(type_of_animal, name)

#Owner class
  #initialize(persons_name)
    #number_of_pets = 0

#Shelter class
  #adopt(owner_class_object, pet_class_object)

  #print_adoptions
    #{owner_class_name} has adopted the following pets:
      #each element in an array of adopted pets "a #{pet.type} named #{pet.name}"

class Pet

  attr_reader :name, :type_of_animal

  def initialize(type_of_animal, name, shelter_instance)
    @type_of_animal = type_of_animal
    @name = name
    shelter_instance.add_pet(self)
  end

  def to_s
    "a #{type_of_animal} named #{name}"
  end
end

class Owner
  attr_accessor :name, :pets, :number_of_pets

  def initialize(name)
    @name = name
    @pets = []
    @numbet_of_pets = 0
  end

  def add_pet(pet)
    @pets << pet
    @number_of_pets = @pets.size
  end

  def print_pets
    puts pets
  end
end

class Shelter

  attr_accessor :pets_in_shelter

  def initialize
    @pets_in_shelter = []
    @owners = {}
  end

  def add_pet(pet)
    @pets_in_shelter << pet
  end

  def adopt(owner, pet)
    owner.add_pet(pet)
    @pets_in_shelter.delete(pet)
    @owners[owner.name] ||= owner
  end

  def print_adoptions
    @owners.each_pair do |name, owner|
      puts "\n#{name} has adopted the following pets:"
      owner.print_pets
    end
  end

  def print_unadopted_pets
    puts "The shelter has the following unadopted pets: "
    puts @pets_in_shelter
  end

end

shelter = Shelter.new

butterscotch = Pet.new('cat', 'Butterscotch', shelter)
pudding      = Pet.new('cat', 'Pudding', shelter)
darwin       = Pet.new('bearded dragon', 'Darwin', shelter)
kennedy      = Pet.new('dog', 'Kennedy', shelter)
sweetie      = Pet.new('parakeet', 'Sweetie Pie', shelter)
molly        = Pet.new('dog', 'Molly', shelter)
chester      = Pet.new('fish', 'Chester', shelter)
asta       = Pet.new('dog', 'Asta', shelter)
laddie     = Pet.new('dog', 'Laddie', shelter)
fluffy     = Pet.new('cat', 'Fluffy', shelter)
kat        = Pet.new('cat', 'Kat', shelter)
ben        = Pet.new('cat', 'Ben', shelter)
chatterbox = Pet.new('parakeet', 'Chatterbox', shelter)
bluebell   = Pet.new('parakeet', 'Bluebell', shelter)

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)

shelter.print_unadopted_pets
puts "\n--"

puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "The Animal shelter has #{shelter.pets_in_shelter.size} unadopted pets."