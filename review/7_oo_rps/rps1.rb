require 'pry'

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end

  def display_score
    if score == 1
      puts "#{name} has 1 point."
    else
      puts "#{name} has #{score} points."
    end
  end
end

class Human < Player
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
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
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
  WINNING_SCORE = 3

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

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

  def reset_scores
    human.score = 0
    computer.score = 0
  end

  def play_round
    human.choose
    computer.choose
    display_moves
    display_round_winner
    update_scores
    display_scores
  end

  def play
    display_welcome_message

    loop do
      play_round until game_winner
      display_game_winner
      break unless play_again?
      reset_scores
    end

    display_goodbye_message
  end
end

RPSGame.new.play
