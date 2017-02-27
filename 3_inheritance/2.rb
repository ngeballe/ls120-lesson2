class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Cat < Pet
  def speak
    'meow!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

spot = Dog.new
puts spot.speak == "bark!"
puts spot.run == "running!"
puts spot.jump == "jumping!"
puts spot.swim == "swimming!"
puts spot.fetch == "fetching!"

mushroom = Cat.new
puts mushroom.speak == "meow!"
puts mushroom.run == "running!"
puts mushroom.jump == "jumping!"
puts mushroom.respond_to?(:swim) == false
puts mushroom.respond_to?(:fetch) == false

pet = Pet.new
puts pet.run == "running!"
puts pet.jump == "jumping!"
puts pet.respond_to?(:swim) == false
puts pet.respond_to?(:fetch) == false
puts pet.respond_to?(:speak) == false

p Bulldog.ancestors
