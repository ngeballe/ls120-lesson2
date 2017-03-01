require 'pry'

# Rock, Paper, Scissors is a 2-player game where players take turns making a move: choosing rock, paper, or scissors. The moves are compared to determine the winner, according to the rules:
# - rock beats scissors
# - scissors beats paper
# - paper beats rock
# If players choose the same move, it's a tie.

# Nouns: game, player, move, rock, paper, scissors, winner, tie
# Verbs: taker, compare, beat, choose

# Nouns: player, move, rule
# Verbs: choose, compare

# Player
# - choose
# Move
# Rule

# - compare

class Player
  attr_accessor :move, :name

  def initialize
    set_name
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
      puts 'Please choose rock, paper, or scissors:'
      choice = gets.chomp
      break if %w(rock paper scissors).include?(choice)
      puts 'Sorry, invalid choice.'
    end
    self.move = choice
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = %w(rock paper scissors).sample
  end
end

class Move
  def initialize
  end
end

class Rule
  def initialize
    
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_winner
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
    case human.move
    when 'rock'
      puts "It's a tie!" if computer.move == 'rock'
      puts "#{human.name} won!" if computer.move == 'scissors'
      puts "#{computer.name} won!" if computer.move == 'paper'
    when 'paper'
      puts "It's a tie!" if computer.move == 'paper'
      puts "#{human.name} won!" if computer.move == 'rock'
      puts "#{computer.name} won!" if computer.move == 'scissors'
    when 'scissors'
      puts "It's a tie!" if computer.move == 'scissors'
      puts "#{human.name} won!" if computer.move == 'paper'
      puts "#{computer.name} won!" if computer.move == 'rock'
    end
  end

  def display_goodbye_message
    puts "Goodbye! Thanks for playing Rock, Paper, Scissors!"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if %w(y n).include?(answer.downcase)
      puts "Sorry, must be y or n"
    end
    answer == 'y'
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_winner
      break unless play_again?
    end
    
    display_goodbye_message
  end
end

RPSGame.new.play
