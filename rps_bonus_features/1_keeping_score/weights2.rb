require 'pry'

weights = { 'Huskies' => 0.4, 'Warriors' => 0.3, 'Suns' => 0.2, 'Lakeside' => 0.06, 'Caltech' => 0.04 }

def get_ranges(weights)
  ranges = {}
  cumulative_weight_sum = 0
  weights.each do |team, weight|
    ranges[team] = (cumulative_weight_sum)..(cumulative_weight_sum + weight)
    cumulative_weight_sum += weight
  end
  ranges
end

range_hash = get_ranges(weights)

p range_hash

results = []

1_000_000.times do
  decider = rand
  range_hash.each do |team, range|
    if range.include?(decider)
      results << team
      break
    end
  end
end

p results.group_by { |result| result }.map { |team, wins| [team, wins.count.to_f / results.size] }.sort_by { |_, win_fraction| win_fraction }.reverse
