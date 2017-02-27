
# Modify the class definition from above to facilitate the following methods. Note that there is no name= setter method now.

class Person
  attr_reader :first_name
  attr_accessor :last_name

  def initialize(full_name)
    if full_name.include?(" ")
      @first_name, @last_name = full_name.split
    else
      @first_name = full_name
      @last_name = ""
    end
  end

  def name
    last_name.empty? ? first_name : "#{first_name} #{last_name}"
  end
end

bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'
