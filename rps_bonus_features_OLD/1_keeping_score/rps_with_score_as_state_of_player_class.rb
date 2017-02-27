require 'pry'

class Move
  attr_accessor :value

  VALUES = %w(rock paper scissors).freeze

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == "scissors"
  end

  def rock?
    @value == "rock"
  end

  def paper?
    @value == "paper"
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    other_move > self
  end

  def to_s
    value
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    self.score = 0
  end

  def update_score(other_player)
    if move > other_player.move
      self.score += 1
    elsif move < other_player.move
      other_player.score += 1
    end
  end

  def display_score
    puts "#{name} has #{score} points."
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.strip.empty?
      puts "Sorry, you must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = %w(R2D2 Hal).sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  WINNING_SCORE = 10

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, #{human.name}!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Goodbye!"
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
      puts "It's a tie!"
    end
  end

  def update_scores
    human.update_score(computer)
  end

  def display_scores
    [human, computer].each(&:display_score)
  end

  def display_game_winner
    if human.score >= WINNING_SCORE
      puts "#{human.name} won the game!"
    elsif computer.score >= WINNING_SCORE
      puts "#{computer.name} won the game!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Do you want to play again? (y/n)"
      answer = gets.chomp
      break if %w(y n).include? answer.downcase
      puts "Sorry, must be 'y' or 'n'"
    end
    answer == "y"
  end

  def play_round
    human.choose
    computer.choose
    display_moves
    display_winner
    update_scores
    display_scores
  end

  def play
    display_welcome_message

    loop do
      loop do
        play_round
        break if computer.score >= WINNING_SCORE || human.score >= WINNING_SCORE
      end
      display_game_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
