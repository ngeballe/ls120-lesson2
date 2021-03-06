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

  # experimental
  def <=>(other_move)
    if self > other_move
      1
    elsif self < other_move
      -1
    else
      0
    end
  end

  def to_s
    value
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
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

  attr_accessor :human, :computer, :round_winner

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score = { @human => 0, @computer => 0 }
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

  def detect_winner
    self.round_winner = if human.move > computer.move
                          human
                        elsif human.move < computer.move
                          computer
                        end
  end

  def display_winner
    case round_winner
    when human
      puts "#{human.name} won!"
    when computer
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def update_score
    if round_winner
      @score[round_winner] += 1
    end
  end

  def display_score
    @score.each do |player, points|
      puts "#{player.name} has #{points} points."
    end
  end

  def display_game_winner
    winner = @score.max_by { |_, points| points }[0]
    puts "#{winner.name} won the game!"
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

  def someone_won_game?
    @score.values.max >= WINNING_SCORE
  end

  def play_round
    human.choose
    computer.choose
    display_moves
    detect_winner
    display_winner
    update_score
    display_score
  end

  def play
    display_welcome_message

    loop do
      loop do
        self.round_winner = nil
        play_round
        break if someone_won_game?
      end
      display_game_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
