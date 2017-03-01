class Animal
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Animal
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

class Cat < Animal
  def speak
    'meow!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

pete = Animal.new
kitty = Cat.new
dave = Dog.new
bud = Bulldog.new

p pete.run                # => "running!"
# pete.speak              # => NoMethodError

p kitty.run               # => "running!"
p kitty.speak             # => "meow!"
# kitty.fetch             # => NoMethodError

dave.speak              # => "bark!"

p bud.run                 # => "running!"
p bud.swim                # => "can't swim!"
