require "pry"

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

class Score
  WINNING_SCORE = 3

  def initialize(*players)
    @values = {}
    players.each do |player|
      @values[player] = 0
    end
  end

  def display
    @values.each do |player, points|
      points_pluralized = points == 1 ? "point" : "points"
      puts "#{player.name} has #{points} #{points_pluralized}."
    end
  end

  def update(human, computer)
    if human.move > computer.move
      @values[human] += 1
    elsif computer.move > human.move
      @values[computer] += 1
    end
  end

  def someone_won_game?
    @values.values.max >= WINNING_SCORE
  end

  def game_winner
    @values.detect { |_, points| points >= WINNING_SCORE }[0]
  end

  def declare_game_winner
    if game_winner
      puts "#{game_winner.name} won the game!"
    end
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
    score.update(human, computer)
    score.display
  end

  def play
    display_welcome_message
    score = Score.new(human, computer)

    loop do
      loop do
        play_round
        if score.someone_won_game?
          score.declare_game_winner
          break
        end
      end
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
