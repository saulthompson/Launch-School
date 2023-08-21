class Pet
  attr_reader :species, :name
  @@pets = []
  def initialize(species, name)
    @species = species
    @name = name
    @@pets << self
  end
  
  
  def self.pets
    @@pets
  end
end

class Owner
  attr_reader :pets, :name
  
  def initialize(name)
    @pets = []
    @name = name
  end
  
  def add_pet pet
    @pets << pet
  end
  
  def number_of_pets
    @pets.size
  end
end

class Shelter
  
  def initialize
    @owners = []
    @unadopted = Pet::pets
  end
  
  def adopt(owner, pet)
    owner.add_pet pet
    @owners << owner unless @owners.include?(owner)
    @unadopted.delete(pet)
  end
  
  
  def print_unadopted
    puts "The animal shelter has the following unadopted pets:"
    unadopted.each {|pet| puts pet.name}
    puts "The animal shelter has #{unadopted.size} unadopted pets."
  end
  
  def print_adoptions
    @owners.each do |owner|
      puts "#{owner.name} has adopted the following pets:"
      owner.pets.each do |pet|
        puts "a #{pet.species} named #{pet.name}"
      end
      puts
    end
  end
end


butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."

shelter.print_unadopted