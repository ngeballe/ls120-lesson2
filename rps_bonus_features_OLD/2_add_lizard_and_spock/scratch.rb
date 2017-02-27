
class Array
  def join_or
    return self[0] if self.size <= 1
    return self.join(" or ") if self.size == 2
    self[0..-2].join(", ") + ", or #{self.last}"
  end
end

p [].join_or
p %w(joe).join_or
p %w(John Kate).join_or
p %w(Thomasina Della Harriet).join_or


