class Dog
  BONE = "Ken Bone"

  def initialize
    x = Roger.new
  end
end

class Roger
  # CONSTANT = Dog::BONE.size
  @@class_var = Dog::BONE.size

  def initialize
    p @@class_var
  end
end

p Roger.new
