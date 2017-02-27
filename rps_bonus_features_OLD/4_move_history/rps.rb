
class Move
  attr_accessor :value

  VALUES = %w(rock paper scissors)

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

  def to_s
    value
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
    (scissors? && other_move.paper?) ||
    (paper? && other_move.rock?)
  end

  def <(other_move)
    other_move > self
  end
end

class Player
  attr_accessor :name, :move

  def initialize
    set_name
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
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, that's not a valid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['Hal', 'R2D2', 'Deep Blue'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
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

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie."
    end
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

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
