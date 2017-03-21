class Thing
  def self.easy
    puts "It's as easy as #{@@cv}!"
  end

  private

  @@cv = 3.14159
end

p Thing.easy
