# Continuing with our Person class definition, what does the below print out?

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

  # adding...
  def to_s
    name
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

bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"

## It prints "The person's name is: #<Person...."

# After adding the to_s method, it prints

# "The person's name is: Robert Smith"
