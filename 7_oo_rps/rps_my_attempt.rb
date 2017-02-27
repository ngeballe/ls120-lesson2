
# Write a textual description of the problem or exercise.

'''
Rock, Paper, Scissors is a 2-player game where each player chooses one of three possible moves: rock, paper, or scissors. The chosen moves will then be compared to see who wins, according to the following rules:

  - rock beats scissors
  - scissors beats paper
  - paper beats rock

If the players choose the same move, then it\'s a tie.
'''

# Extract the major nouns and verbs from the description.

'''
Nouns: player, move, rule
Verbs: choose, compare
'''

# Organize and associate the verbs with the nouns.

'''
Player
- choose
Move
Rule

- compare = where?
'''
# The nouns are the classes and the verbs are the behaviors or methods.

class Player
  def initialize
    # name? move?
  end

  def choose
    possible_moves = %w(rock paper scissors)
    possible_moves.sample
  end
end

class Move
  def initialize
    # rock, paper, scissors
  end
end

class Rule
  def initialize
  end
end

def compare(move1, move2) # put it under rule?
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Player.new
    @computer = Player.new
  end

  def play
    display_welcome_message
    human_move = @human.choose
    computer_move = @computer.choose
    p human_move
    p computer_move
    # display_winner
    # display_goodbye_message
  end

  def display_welcome_message
    puts "Welcome to Rock-Paper-Scissors!"
  end
end

RPSGame.new.play
