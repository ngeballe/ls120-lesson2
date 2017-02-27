### Write a textual description of the problem or exercise.

# Prisoner's Dilemma is a 2-player game where each player chooses one of two possible moves: cooperate or defect. Each player chooses without knowing the other player's choice.

# If both players cooperate, they both gain 3 points. If one defects and the other cooperates, the defector gets 4 points and the cooperator gets 0. If both defect, they gain 2 points each.

# How many rounds?

### Extract the major nouns and verbs from the description.

# Nouns: player, move, points
# verbs choose, coopearte, defect

### Organize and associate the verbs with the nouns
# Player 
# - choose
# Move
# Rule

require 'pry'

class Player
  attr_accessor :move, :score

  def initialize
    self.score = 0
  end

  def cooperate?
    move.value == "cooperate"
  end

  def defect?
    move.value == "defect"
  end

  def update_score(other_player)
    if cooperate? && other_player.cooperate?
      self.score += 3
    elsif defect? && other_player.cooperate?
      self.score += 4
    elsif cooperate? && other_player.defect?
      self.score += 0
    elsif defect? && other_player.defect?
      self.score += 2
    end
  end
end

class Computer < Player
  attr_accessor :opponents_previous_move

  def choose
    # self.move = random_choice
    tit_for_tat
  end

  def display_score
    puts "The computer has #{score} points."
  end

  private

  def random_choice
    Move.new(Move::CHOICES.sample) # choose randomly
  end

  def tit_for_tat
    if opponents_previous_move.nil?
      self.move = Move.new("cooperate")
    else
      self.move = Move.new(opponents_previous_move.value)
    end
  end

end

class Human < Player
  def choose
    choice = nil
    loop do
      puts "Which do you want to do: cooperate or defect?"
      puts "(You can enter 'c' for cooperate and 'd' for defect.)"
      choice = gets.chomp
      break if Move::CHOICES.include?(choice) || Move::CHOICES.map { |choice| choice[0] }
    end
    self.move = Move.new(choice)
  end

  def display_score
    puts "You have #{score} points."
  end
end

class Move
  CHOICES = %w(cooperate defect)

  attr_accessor :value

  def initialize(choice)
    if choice.size == 1
      self.value = CHOICES.detect { |valid_choice| valid_choice.start_with?(choice) }
    else
      self.value = choice
    end
  end

  def to_s
    value
  end
end

class PrisonersDilemmaGame
  attr_reader :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Prisoner's Dilemma."
  end

  def display_moves
    puts "You chose to #{human.move}."
    puts "The computer chose to #{computer.move}."
  end

  def update_scores
    human.update_score(computer)
    computer.update_score(human)
  end

  def display_scores
    [human, computer].each(&:display_score)
  end

  def display_goodbye_message
    puts "Thanks for playing. Goodbye!"
  end

  def play_round
    human.choose
    computer.choose
    computer.opponents_previous_move = human.move
    display_moves
    update_scores
    display_scores
  end

  def play
    display_welcome_message
    (1..3).each do |round_number|
      puts "Round #{round_number}:"
      play_round
    end
    display_goodbye_message
  end
end

PrisonersDilemmaGame.new.play

