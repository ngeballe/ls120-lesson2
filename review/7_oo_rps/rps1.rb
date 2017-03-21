require 'pry'

class Player
  attr_accessor :move, :name, :score, :move_history

  def initialize
    set_name
    reset_data
  end

  def display_score
    if score == 1
      puts "#{name} has 1 point."
    else
      puts "#{name} has #{score} points."
    end
  end

  def update_move_history
    move_history << move
  end

  def display_move_history
    print "#{name}'s move history: "
    moves_numbered = @move_history.map.with_index do |move, index|
      "#{index + 1}. #{move}"
    end
    puts moves_numbered.join(', ')
  end

  def reset_data
    @score = 0
    @move_history = []
  end
end

class Human < Player
  def choose
    choice = nil
    loop do
      puts 'Please choose rock, paper, scissors, lizard, or spock:'
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts 'Sorry, invalid choice.'
    end
    self.move = Move.new(choice)
  end

  private

  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, you must enter a value."
    end
    self.name = n
  end
end

class Computer < Player
  NAMES = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5', 'Deep Blue']
    # ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']
    # if R2D2 = 0.5 rock, 0.5 spock, no updating
    # Hal -- 0.3 rock, 0.3 paper, 0.3 scissors, 0.1 lizard, 0 spock, updating w/ weight 0.5
    # if Chappie -- 0.1 rock, 0.4 scissors, 0.2 spock, 0.2 lizard, 0.1 paper, no updating
    # Sonny -- 0.2 for all, updating w/ weight 1.0
    # Number 5 -- 0.2 for all, no updating
    # Deep Blue -- 0.2 for all, updating w/ weight 0.2
  NAME_TO_BASE_RATES = {
    'R2D2' => { 'rock' => 0.5, 'paper' => 0, 'scissors' => 0, 'lizard' => 0, 'spock' => 0.5 },
    'Hal' => { 'rock' => 0.3, 'paper' => 0.3, 'scissors' => 0.3, 'lizard' => 0.1, 'spock' => 0 },
    'Chappie' => { 'rock' => 0.1, 'paper' => 0.1, 'scissors' => 0.4, 'lizard' => 0.2, 'spock' => 0.2 },
    'Sonny' => { 'rock' => 0.2, 'paper' => 0.2, 'scissors' => 0.2, 'lizard' => 0.2, 'spock' => 0.2 },
    'Number 5' => { 'rock' => 0.2, 'paper' => 0.2, 'scissors' => 0.2, 'lizard' => 0.2, 'spock' => 0.2 },
    'Deep Blue' => { 'rock' => 0.2, 'paper' => 0.2, 'scissors' => 0.2, 'lizard' => 0.2, 'spock' => 0.2 }
  }

  NAME_TO_CURRENT_GAME_WEIGHT = { 'R2D2' => 0, 'Hal' => 0.5, 'Chappie' => 0, 'Sonny' => 1.0, 'Number 5' => 0, 'Deep Blue' => 0 } 

  def choose
    # move_value = if move_history.empty?
    #                Move::VALUES.sample
    #              else
    #                move_value_based_on_probabilities
    #              end
    self.move = Move.new(move_value_based_on_probabilities)
  end

  def reset_data
    super
    reset_move_probabilities
  end

  def update_move_probabilities(round_winner)
    move_value = move.to_s
    return if NAME_TO_CURRENT_GAME_WEIGHT[name].zero? 
    
    if round_winner == self
      @move_probabilities[move_value].wins += 1
    elsif round_winner && round_winner != self
      @move_probabilities[move_value].losses += 1
    end

    binding.pry
    @move_probabilities.values.each(&:update_probability)
  end

  private

  def set_name
    ### TEMPORARY
    # self.name = NAMES.sample
    self.name = %w(Hal Sonny).sample
  end

  def move_value_based_on_probabilities
    # adjust to get thresholds for choosing
    # [0.2, 0.2, 0.4, 0.1, 0.1] => [0.2, 0.4, 0.8, 0.9, 1.0]
    move_thresholds = {}
    # probabilities = 
    # probabilities = @move_probabilities
    probabilities = Move::VALUES.zip(@move_probabilities.values.map(&:probability)).to_h
    p probabilities
    probabilities.each_with_index do |(move_value, _), index|
      move_thresholds[move_value] = \
        probabilities.values[0..index].reduce(:+)
    end
    random_number = rand
    Move::VALUES.detect { |mv| random_number < move_thresholds[mv] }
  end

  # def final_probabilities
  #   result = {}
  #   probabilities = @move_probabilities.map { |_, v| v.adjusted_probability }
  #   # make them add up to 1
  #   normalized_probabilities = probabilities.map do |element|
  #     element / probabilities.reduce(:+).to_f
  #   end
  #   @move_probabilities.each_with_index do |(move_value, _), index|
  #     result[move_value] = normalized_probabilities[index]
  #   end
  #   result
  # end

  def reset_move_probabilities
    base_rates = NAME_TO_BASE_RATES[name]   
    current_game_weight = NAME_TO_CURRENT_GAME_WEIGHT[name] 

    @move_probabilities = {}
    base_rates.each do |move_value, base_rate|
      @move_probabilities[move_value] = \
        MoveProbability.new(base_rate, current_game_weight)
    end
  end
end

class Move
  VALUES = %w[rock paper scissors lizard spock]

  attr_reader :value

  def initialize(value)
    @value = case value
             when 'rock' then Rock.new
             when 'paper' then Paper.new
             when 'scissors' then Scissors.new
             when 'lizard' then Lizard.new
             when 'spock' then Spock.new
             end
  end

  def >(other_move)
    value > other_move.value
  end

  def <(other_move)
    other_move > self
  end

  def to_s
    @value.to_s
  end
end

class MoveProbability
  attr_accessor :wins, :losses
  attr_reader :probability
  # attr_reader :adjusted_probability

  def initialize(base_rate, current_game_weight)
    @base_rate = base_rate
    @success_rate_this_game = nil
    @current_game_weight = current_game_weight
    unless @current_game_weight.zero?
      @wins = 0
      @losses = 0
    end
  end

  def update_probability
    # binding.pry
    @probability = @probability * (1 - @current_game_weight) + \
      success_rate_this_game * @current_game_weight
  end

  # private

  def update_success_rate_this_game
    return if @wins == 0 && @losses == 0
    @success_rate_this_game = @wins.to_f / (@wins + @losses)
  end
end

class Rock
  def >(other)
    [Scissors, Lizard].include?(other.class)
  end

  def to_s
    'rock'
  end
end

class Paper
  def >(other)
    [Rock, Spock].include?(other.class)
  end

  def to_s
    'paper'
  end
end

class Scissors
  def >(other)
    [Paper, Lizard].include?(other.class)
  end

  def to_s
    'scissors'
  end
end

class Lizard
  def >(other)
    [Paper, Spock].include?(other.class)
  end

  def to_s
    'lizard'
  end
end

class Spock
  def >(other)
    [Rock, Scissors].include?(other.class)
  end

  def to_s
    'spock'
  end
end

class RPSGame
  WINNING_SCORE = 10

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play
    display_welcome_message

    loop do
      play_round until game_winner
      display_game_winner
      break unless play_again?
      reset_game
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def round_winner
    if human.move > computer.move
      human
    elsif human.move < computer.move
      computer
    end
  end

  def display_round_winner
    case round_winner
    when human
      puts "#{human.name} won!"
    when computer
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def update_scores
    round_winner.score += 1 if round_winner
  end

  def display_scores
    human.display_score
    computer.display_score
  end

  def game_winner
    if human.score == WINNING_SCORE
      human
    elsif computer.score == WINNING_SCORE
      computer
    end
  end

  def display_game_winner
    puts "#{game_winner.name} won the game!"
  end

  def display_goodbye_message
    puts "Goodbye! Thanks for playing Rock, Paper, Scissors, Lizard, Spock!"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if %w[y n].include?(answer.downcase)
      puts "Sorry, must be y or n"
    end
    answer.downcase == 'y'
  end

  def reset_game
    human.reset_data
    computer.reset_data
  end

  def update_and_display_move_histories
    [human, computer].each(&:update_move_history)
    [human, computer].each(&:display_move_history)
    computer.update_move_probabilities(round_winner)
  end

  def play_round
    human.choose
    computer.choose
    update_and_display_move_histories
    display_moves
    display_round_winner
    update_scores
    display_scores
  end
end

RPSGame.new.play
