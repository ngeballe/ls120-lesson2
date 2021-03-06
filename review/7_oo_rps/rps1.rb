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
  NAME_TO_BASE_RATES = {
    'R2D2' => { 'rock' => 0.5, 'paper' => 0, 'scissors' => 0,
                'lizard' => 0, 'spock' => 0.5 },
    'Hal' => { 'rock' => 0.3, 'paper' => 0.3, 'scissors' => 0.3,
               'lizard' => 0.1, 'spock' => 0 },
    'Chappie' => { 'rock' => 0.1, 'paper' => 0.1, 'scissors' => 0.4,
                   'lizard' => 0.2, 'spock' => 0.2 },
    'Sonny' => { 'rock' => 0.2, 'paper' => 0.2, 'scissors' => 0.2,
                 'lizard' => 0.2, 'spock' => 0.2 },
    'Number 5' => { 'rock' => 0.2, 'paper' => 0.2, 'scissors' => 0.2,
                    'lizard' => 0.2, 'spock' => 0.2 },
    'Deep Blue' => { 'rock' => 0.2, 'paper' => 0.2, 'scissors' => 0.2,
                     'lizard' => 0.2, 'spock' => 0.2 }
  }
  NAME_TO_CURRENT_GAME_WEIGHT = { 'R2D2' => 0, 'Hal' => 0.5,
                                  'Chappie' => 0, 'Sonny' => 1.0,
                                  'Number 5' => 0, 'Deep Blue' => 0 }

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

  def reset_move_probabilities
    @move_probabilities = {}
    Move::VALUES.each do |move_value|
      base_rate = NAME_TO_BASE_RATES[name][move_value]
      current_game_weight = NAME_TO_CURRENT_GAME_WEIGHT[name]
      mp = MoveProbability.new(base_rate, current_game_weight)
      @move_probabilities[move_value] = mp
    end
  end

  def update_move_probabilities(round_winner)
    move_value = move.to_s
    return if NAME_TO_CURRENT_GAME_WEIGHT[name].zero?

    if round_winner == self
      @move_probabilities[move_value].wins += 1
    elsif round_winner && round_winner != self
      @move_probabilities[move_value].losses += 1
    end

    @move_probabilities.values.each(&:update_probability)
    # adjust the probabilities so they add up to 1

    # set probabilities to normalized
    @move_probabilities.values.each do |mp|
      mp.adjusted_probability = normalized_probabilities.shift
    end
  end

  def normalized_probabilities
    sum_of_adjusted = adjusted_probabilities.reduce(:+)
    adjusted_probabilities.map { |ap| ap.to_f / sum_of_adjusted }
  end

  def adjusted_probabilities
    @move_probabilities.values.map(&:adjusted_probability)
  end

  def move_value_based_on_probabilities
    # pick a random number as the decider
    decider = rand
    # get ranges for each value
    move_values_to_ranges.keys.detect do |mv|
      # range matches
      move_values_to_ranges[mv].cover?(decider)
    end
  end

  private

  def move_values_to_adjusted_probabilities
    Hash[@move_probabilities.keys.zip(adjusted_probabilities)]
  end

  def move_values_to_ranges
    keys = move_values_to_adjusted_probabilities.keys
    values = move_values_to_adjusted_probabilities.values
    ranges = values.each_index.map do |idx|
      range_start = values[0...idx].reduce(0, :+)
      range_end = values[0..idx].reduce(:+)
      range_start..range_end
    end
    Hash[keys.zip(ranges)]
  end

  def set_name
    ### TEMPORARY
    # self.name = NAMES.sample
    # self.name = %w(Hal Sonny).sample
    self.name = 'Hal'
  end

  def current_game_weight
    NAME_TO_CURRENT_GAME_WEIGHT[name]
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
  attr_accessor :wins, :losses, :adjusted_probability
  attr_reader :probability, :base_rate, :success_rate_this_game

  def initialize(base_rate, current_game_weight)
    @base_rate = base_rate
    @success_rate_this_game = nil
    @current_game_weight = current_game_weight
    @adjusted_probability = base_rate
    @wins = @losses = 0 unless @current_game_weight.zero?
  end

  def update_probability
    update_success_rate_this_game

    @adjusted_probability = if @success_rate_this_game.nil?
                              @base_rate
                            else
                              @base_rate * (1 - @current_game_weight) + \
                                @success_rate_this_game * @current_game_weight
                            end
    # binding.pry
    # @probability = @probability * (1 - @current_game_weight) + \
    #  success_rate_this_game * @current_game_weight
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
