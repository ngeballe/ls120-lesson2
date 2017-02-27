class Person
  attr_accessor :name

  def initialize(n)
    @name = n
  end
end

bob = Person.new('bob')
p bob.name                  # => 'bob'
bob.name = 'Robert'
p bob.name                  # => 'robert'  
