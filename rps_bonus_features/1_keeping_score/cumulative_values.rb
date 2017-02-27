# def get_cumulative_values(array)
#   array.each_index.map { |index| array[0..index].reduce(:+) }
# end

# array = [8, 3, 7, 10, 12]

# p get_cumulative_values(array)

# p get_cumulative_values([9, 4, 0, 6, 2]) == [9, 13, 13, 19, 21]
# p get_cumulative_values([9, 1, 1, -3, 2, 8, 6]) == [9, 10, 11, 8, 10, 18, 24]

def get_cumulative_weigths(hash)
  # array.each_index.map { |index| array[0..index].reduce(:+) }
  total_so_far = 0
  hash.each do |k, v|
    total_so_far += v
    hash[k] = total_so_far
  end
  hash
end

options = %w(Huskies Warriors Suns)

weights = { 'Huskies' => 0.3, 'Warriors' => 0.19, 'Suns' => 0.51 }

p get_cumulative_weigths(weights)
