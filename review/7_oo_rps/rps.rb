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
  attr_reader :move

  VALID_MOVE_CHOICES = %w(rock paper scissors)

  def initialize
    # name, move?
  end

  def move_beats?(other)
    (move == 'rock' && other.move == 'scissors') ||
    (move == 'scissors' && other.move == 'paper') ||
    (move == 'paper' && other.move == 'rock')
  end
end

class Human < Player
  def choose
    choice = ''
    puts 'Choose rock, paper, or scissors.'
    loop do
      choice = gets.chomp
      break if VALID_MOVE_CHOICES.include?(choice)
      puts "That's not a valid choice. Choose rock, paper or scissors."
    end
    @move = choice
    puts "You chose #{move}."
  end
end

class Computer < Player
  def choose
    @move = VALID_MOVE_CHOICES.sample
    puts "The computer chose #{move}."
  end
end

class Move
end

class RPSGame
  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_winner
    if @human.move_beats?(@computer)
      puts 'You won!'
    elsif @computer.move_beats?(@human)
      puts 'The computer won!'
    else
      puts "It's a tie!"
    end
  end

  def display_goodbye_message
    puts "Goodbye! Thanks for playing!"
  end

  def play
    display_welcome_message
    @human.choose
    @computer.choose
    display_winner
    display_goodbye_message
  end
end

RPSGame.new.play
