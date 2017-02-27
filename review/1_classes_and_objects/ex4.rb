# Using the class definition from step #3, let's create a few more people -- that is, Person objects.

class Person
  attr_accessor :first_name, :last_name

  def initialize(first_or_full)
    set_name(first_or_full)
  end

  def name=(first_or_full)
    set_name(first_or_full)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  private

  def set_name(first_or_full)
    if first_or_full.include?(" ")
      @first_name = first_or_full.split.first
      @last_name = first_or_full.split.last
    else
      @first_name = first_or_full
      @last_name = ''
    end  
  end
end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

p bob.name == rob.name
