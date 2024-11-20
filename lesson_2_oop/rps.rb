class Move
  VALUES = ['rock', 'paper', 'scissors']

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
    if rock?
      return true if other_move.scissors?
    elsif paper?
      return true if other_move.rock?
    elsif scissors?
      return true if other_move.paper?
    end

    return false
  end

  def to_s
    @value
  end

  def <(other_move)
    if rock?
      return true if other_move.paper? # Rock loses to Paper
    elsif paper?
      return true if other_move.scissors? # Paper loses to Scissors
    elsif scissors?
      return true if other_move.rock? # Scissors lose to Rock
    end

    return false
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ["R2D2", "Hal", "Iris"].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

# Game Orchestration Engine
class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to RPS (Rock, Paper, Scissors) #{human.name}!"
    sleep(0.5)
    puts "The game will end when the first player reaches a score of 10."
    puts "However, you can quit the game before that."
    puts "\n"
    sleep(0.5)
  end

  def display_goodbye_message
    if human.score == 10 || computer.score == 10
      puts "One player has reached a score of 10. The game will close down now."
      puts "Goodbye!"
    else
      puts "Thanks for playing Rock, Paper, Scissors. Good bye!"
    end
  end

  def determine_winner
    if human.move > computer.move
      return "#{human.name}"
    elsif human.move < computer.move
      return "#{computer.name}"
    else
      return "Nobody"
    end
  end

  def update_score(winner)
    if winner == "#{human.name}"
      human.score += 1
    elsif winner == "#{computer.name}"
      computer.score += 1
    else
      nil
    end
  end


  def display_winner(winner)
    puts "#{human.name} chose #{human.move}."
    sleep(0.5)
    puts "#{computer.name} chose: #{computer.move}."
    sleep(0.5)

    puts "#{winner} won!"
    puts "------"
    sleep(0.5)
    puts "#{human.name} score: #{human.score}"
    puts "#{computer.name} score: #{computer.score}"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would #{human.name} like to play again?(y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end

    return true if answer == 'y'
    false
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      winner = determine_winner
      update_score(winner)
      display_winner(winner)
      break if computer.score == 10 || human.score == 10
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
