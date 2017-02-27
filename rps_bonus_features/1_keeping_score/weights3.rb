def get_ranges(weights)
  ranges = {}
  cumulative_weight_sum = 0
  weights.each do |team, weight|
    ranges[team] = [cumulative_weight_sum, cumulative_weight_sum + weight]
    cumulative_weight_sum += weight
  end
  ranges
end

weights = { 'Huskies' => 0.7, 'Warriors' => 0.3 }
# cumulative_weights = { 'Huskies' => 0.7, 'Warriors' => 1.0 }

p get_ranges(weights)
