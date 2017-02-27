# Now create a smart name= method that can take just a first name or a full name, and knows how to set the first_name and last_name appropriately.

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

bob = Person.new('Robert')
p bob.name == 'Robert'                # => 'Robert'
p bob.first_name == 'Robert'           # => 'Robert'
p bob.last_name == ''            # => ''
bob.last_name = 'Smith'
p bob.name == 'Robert Smith'              # => 'Robert Smith'

bob.name = "John Adams"
p bob.first_name == 'John'          # => 'John'
p bob.last_name == 'Adams'            # => 'Adams'
