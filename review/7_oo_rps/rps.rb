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
  def initialize
    # name, move?
  end

  def choose
    
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

def compare(move1, move2)
  
end

class RPSGame
  def initialize
    @human = Player.new
    @computer = Player.new
  end

  def play
    display_welcome_message
    @human.choose
    @computer.choose
    display_winner
    display_goodbye_message
  end
end
