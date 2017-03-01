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
  attr_accessor :move

  def initialize(player_type = :human)
    @player_type = player_type
    @move = nil
  end

  def choose
    if human?
      choice = nil
      loop do
        puts 'Please choose rock, paper, or scissors:'
        choice = gets.chomp
        break if %w(rock paper scissors).include?(choice)
        puts 'Sorry, invalid choice.'
      end
      self.move = choice
    else
      self.move = %w(rock paper scissors).sample
    end
  end

  def human?
    @player_type == :human
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
    @human = Player.new
    @computer = Player.new(:computer)
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Goodbye! Thanks for playing Rock, Paper, Scissors!"
  end

  def play
    display_welcome_message
    human.choose
    computer.choose
    display_winner
    display_goodbye_message
  end
end

RPSGame.new.play
