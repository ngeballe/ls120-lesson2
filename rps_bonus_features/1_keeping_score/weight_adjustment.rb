
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

results = []

# weights = { 'Huskies' => 0.3, 'Warriors' => 0.19, 'Suns' => 0.51 }
weights = { 'Huskies' => 0.42, 'Warriors' => 0.45, 'Suns' => 0.09, 'Lakeside' => 0.039, 'Caltech' => 0.001 }
p weights

cumulative_weights = get_cumulative_weigths(weights)
p cumulative_weights

1.times do
  # choice = options.sample
  decider = rand
  choice = nil
  if decider.between?(0, cumulative_weights.values.first)
    choice = cumulative_weights.keys.first
  end
  weights.each_with_index do |team, cumulative_weight, index|
    p [team, cumulative_weight, index]
    # if decider.between?(cumulative_weights[index], cumulative_weights)
    # end
  end
  # choice = if decider < cumulative_weights['Huskies']
  #             'Huskies'
  #           elsif decider.between?(cumulative_weights['Huskies'], cumulative_weights['Warriors'])
  #             'Warriors'
  #           else
  #             'Suns'
  #           end
  results << choice
end

p results.group_by { |result| result }.map { |team, wins| [team, wins.count.to_f / results.size] }
