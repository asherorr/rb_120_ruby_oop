class Move
  RULES_OF_RPS = {
    "rock": %w[scissors lizard],
    "paper": %w[rock spock],
    "scissors": %w[paper lizard],
    "spock": %w[scissors rock],
    "lizard": %w[spock paper]
  }

  def initialize(value)
    @value = value
  end

  def to_s
    @value.to_s
  end

  def to_sym
    @value
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
      puts "Please choose rock, paper, scissors, lizard, or spock:"
      choice = gets.chomp.downcase.to_sym
      break if Move::RULES_OF_RPS.keys.include? choice
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
    self.move = Move.new(Move::RULES_OF_RPS.keys.sample)
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

  def determine_winner(humans_choice, computers_choice)
    losing_moves = Move::RULES_OF_RPS[humans_choice.to_sym]
    if humans_choice == computers_choice
      return "Nobody"
    elsif losing_moves.include?(computers_choice)
      return "#{human.name}"
    else
      return "#{computer.name}"
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
      human_choice = human.choose
      computer_choice = computer.choose
      winner = determine_winner(human_choice, computer_choice)
      update_score(winner)
      display_winner(winner)
      break if computer.score == 10 || human.score == 10
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
