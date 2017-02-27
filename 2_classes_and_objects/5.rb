class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    parse_full_name(name)
  end

  def name
    "#{@first_name} #{@last_name}".strip
  end

  def name=(name)
    parse_full_name(name)
  end

  def to_s
    name
  end

  private

  def parse_full_name(name)
    parts = name.split
    @first_name = parts.first
    @last_name = parts.size > 1 ? parts.last : '' 
  end
end

bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"
puts "The person's name is: " + bob.name
