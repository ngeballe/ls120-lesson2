you   = %w(R P R R S P P R R R)
other = %w(P R S S S P P R S S)

def win?(your_move, other_move)
  (your_move == 'R' && other_move == 'S') ||
  (your_move == 'S' && other_move == 'P') ||
  (your_move == 'P' && other_move == 'R')
end

def loss?(your_move, other_move)
  win?(other_move, your_move)
end

outcomes = []
outcomes = you.map.with_index do |choice, index|
  others_choice = other[index]
  if win?(choice, others_choice)
    1
  elsif loss?(choice, others_choice)
    -1
  else
    0
  end
end

outcomes_by_move_choice = Hash.new(0)
you.map.with_index do |choice, index|
  others_choice = other[index]
  result = if win?(choice, others_choice)
            1
          elsif loss?(choice, others_choice)
            -1
          else
            0
          end
  outcomes_by_move_choice[choice] += result
end




# EVs

p you
p other
p outcomes
puts
p outcomes_by_move_choice

data = {}

%w(R P S).each do |choice|
  data[choice] = {}
  # # times used
  times_used = you.count(choice)
  data[choice][:times_used] = times_used
  wins = losses = ties = 0
  you.each_with_index do |move, index|
    next unless move == choice
    others_choice = other[index]
    if win?(choice, others_choice)
      wins += 1
    elsif loss?(choice, others_choice)
      losses += 1
    else
      ties += 1
    end
  end
  # win
  # loss
  # tie
  data[choice][:wins] = wins
  data[choice][:losses] = losses
  data[choice][:ties] = ties
  # % win
  data[choice][:pct_wins] = wins.to_f / times_used
  # % loss
  data[choice][:pct_losses] = losses.to_f / times_used
  # % tie
  data[choice][:pct_ties] = ties.to_f / times_used
end

data.each do |k, v|
  p k
  p v
  # % of win/losses that are wins
  p v[:wins].to_f / (v[:wins] + v[:losses])
end



