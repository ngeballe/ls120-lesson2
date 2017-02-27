require 'pry'

class Move
  attr_accessor :value

  VALUES = %w(rock paper scissors lizard spock).freeze

  def initialize(value)
    @value = value
  end

  def rock?
    value == 'rock'
  end

  def paper?
    value == 'paper'
  end

  def scissors?
    value == 'scissors'
  end

  def lizard?
    value == 'lizard'
  end

  def spock?
    value == 'spock'
  end

  def >(other_move)
    [['rock', 'scissors'],
     ['scissors', 'paper'],
     ['paper', 'rock'],
     ['spock', 'rock'],
     ['rock', 'lizard'],
     ['scissors', 'lizard'],
     ['spock', 'scissors'],
     ['lizard', 'paper'],
     ['paper', 'spock'],
     ['lizard', 'spock']].include?([value, other_move.value])
  end

  def <(other_move)
    other_move > self
  end

  def to_s
    value
  end
end

class Player
  attr_accessor :name, :move, :score, :move_history, :opponent

  def initialize
    set_name
    self.score = 0
    self.move_history = []
  end

  def score_in_words
    score == 1 ? "1 point" : "#{score} points"
  end

  def update_move_history
    outcome = if move > opponent.move
                1
              elsif move < opponent.move
                -1
              else
                0
              end
    move_history << { move: move, outcome: outcome }
  end

  def move_history_formatted
    move_history.map { |move_data| move_data[:move].value }
  end
end

class Human < Player
  def set_name
    name = ""
    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.strip.empty?
      puts "Sorry, you must enter a value."
    end
    self.name = name
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, or spock:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, that's not a valid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  attr_accessor :personality

  WIN_HISTORY_WEIGHT = 0.5

  def initialize
    super
  end

  def set_name
    self.name = ['Hal', 'R2D2', 'Cosmic AC', 'Deep Blue'].sample
  end

  def choose
    # puts "adjusted_rates: #{adjusted_rates}"
    # puts "ranges_for_move_choice: #{ranges_for_move_choice}"
    # choose with adjusted rate probabilities
    case name
    when 'R2D2'
      self.move = Move.new('rock')
    when 'Hal'
      move_name = (['scissors'] * 5 + ['rock']).sample
      self.move = Move.new(move_name)
    else
      decider = rand
      range = ranges_for_move_choice.keys.detect { |k| k.include?(decider) }
      move_name = ranges_for_move_choice[range]
      self.move = Move.new(move_name)
    end
  end

  private

  def base_rates
    result = {}
    Move::VALUES.map do |move_name|
      result[move_name] = 1.0 / Move::VALUES.size
    end
    result
  end

  def win_rates
    result = {}
    wins = move_history.select { |move_data| move_data[:outcome] == 1 }
    return nil if wins.none?
    Move::VALUES.map do |move_name|
      wins_with_this_move = wins.select do |move_data|
        move_data[:move].value == move_name
      end
      result[move_name] = wins_with_this_move.count.to_f / wins.size
    end
    result
  end

  def adjusted_rates
    return base_rates if win_rates.nil?
    result = {}
    Move::VALUES.each do |move_name|
      base_rate = base_rates[move_name]
      win_rate = win_rates[move_name]
      result[move_name] = (win_rate * WIN_HISTORY_WEIGHT) + \
                          (base_rate * (1 - WIN_HISTORY_WEIGHT))
    end
    result
  end

  def ranges_for_move_choice
    # gets ranges for weighted move choice based on adjusted_rates
    ranges = {}
    cumulative_weight_sum = 0
    adjusted_rates.each do |option, weight|
      range = cumulative_weight_sum..(cumulative_weight_sum + weight)
      ranges[range] = option
      cumulative_weight_sum += weight
    end
    ranges
  end
end

class RPSGame
  WINNING_SCORE = 10

  attr_accessor :human, :computer, :winner

  def initialize
    @human = Human.new
    @computer = Computer.new
    @human.opponent = @computer
    @computer.opponent = @human
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_move_histories
    puts "#{human.name}'s move history: #{human.move_history_formatted}"
    puts "#{computer.name}'s move history: #{computer.move_history_formatted}"
  end

  def detect_winner
    self.winner = if human.move > computer.move
                    human
                  elsif human.move < computer.move
                    computer
                  end
  end

  def display_winner
    if winner
      puts "#{winner.name} won!"
    else
      puts "It's a tie."
    end
  end

  def update_scores
    winner.score += 1 if winner
  end

  def display_scores
    puts "#{human.name} has #{human.score_in_words}."
    puts "#{computer.name} has #{computer.score_in_words}."
  end

  def set_game_winner
    self.winner = if human.score >= WINNING_SCORE
                    human
                  elsif computer.score >= WINNING_SCORE
                    computer
                  end
  end

  def someone_won_game?
    human.score >= WINNING_SCORE || computer.score >= WINNING_SCORE
  end

  def display_game_winner
    puts "#{winner.name} won the game!"
  end

  def play_again?
    answer = nil
    loop do
      puts "Do you want to play again? (y/n)"
      answer = gets.chomp
      break if %(y n).include?(answer.downcase)
      puts "Sorry, you must enter 'y' or 'n'."
    end
    answer == "y"
  end

  def display_goodbye_message
    puts "Thanks for playing! Goodbye!"
  end

  def play_round
    human.choose
    computer.choose
    human.update_move_history
    computer.update_move_history
    display_moves
    display_move_histories
    detect_winner
    display_winner
    update_scores
    display_scores
  end

  def reset_scores
    human.score = 0
    computer.score = 0
  end

  def play
    display_welcome_message

    loop do
      loop do
        play_round
        break if someone_won_game?
      end
      set_game_winner
      display_game_winner
      break unless play_again?
      reset_scores
    end
    display_goodbye_message
  end
end

RPSGame.new.play
