# exploration -- string interpolation

# num = 8
# p "#{num}"
# p num.to_s
# p num.inspect
# p num.inspect.to_s

# float = 9.2
# p "#{float}"
# p float.to_s
# p float.inspect
# p float.inspect.to_s

# string = "Jane"
# p "#{string}"
# p string.to_s
# p string.inspect # => != 
# p string.inspect.to_s

class Class1
end

class Class2
  def to_s
    "a string"
  end
end

class Class3
  def to_s
    :jennifer
  end
end

results = [8, 9.2, "Fred", :sam, [], [8, 4, 7], {1 => 3}, Class1.new, Class2.new].all? do |object|
  "#{object}" == object.to_s
end

p results # => true

object = Class3.new
puts "#{object}" == object.to_s
p "#{object}"
p object.to_s

# If a class's to_s method returns an object that's not a string (which it shouldn't), string interpolation uses object.inspect rather than object.to_s




