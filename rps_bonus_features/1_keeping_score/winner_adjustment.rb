# win_history_weight = 1 # win rates

base_rates = [0.2, 0.2, 0.2, 0.2, 0.2]
win_rates = [1.0, 0.0, 0.0, 0.0, 0.0]

def calculate_adjusted_rates(base_rates, win_rates, win_history_weight)
  base_rates.each_with_index.map do |base_rate, index|
    win_rate = win_rates[index]
    (win_rate * win_history_weight) + (base_rate * (1 - win_history_weight))
  end
end

p calculate_adjusted_rates(base_rates, win_rates, 0.25)
