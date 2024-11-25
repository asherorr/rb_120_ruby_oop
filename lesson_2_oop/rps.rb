class Move
  RULES_OF_RPS = {
    "rock" => %w(scissors lizard),
    "paper" => %w(rock spock),
    "scissors" => %w(paper lizard),
    "spock" => %w(scissors rock),
    "lizard" => %w(spock paper)
  }

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score, :move_history

  def self.add_moves_to_players_history(
    human,
    human_choice,
    computer,
    computer_choice
  )
    human.move_history << human_choice.to_s
    computer.move_history << computer_choice.to_s
  end

  def initialize
    set_name
    @score = 0
    @move_history = []
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break if !n.empty? && /[a-zA-Z']/.match?(n)
      puts "Sorry, you must enter a valid name."
      puts "Examples: Leila, De'Andre, Evan"
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard, or spock:"
      choice = gets.chomp.downcase
      break if Move::RULES_OF_RPS.keys.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice).to_s
  end
end

class Computer < Player
  @@personalities = {
    "R2D2" => ["rock"],
    # R2D2 always chooses rock.
    "Hal" => ["scissors", "spock", "lizard"],
    # Hal will only choose scissors, spock, or lizard.
    "Chappie" => Move::RULES_OF_RPS.keys
    # Chappie likes to pick at random each time.
  }

  def set_name
    self.name = ["R2D2", "Hal", "Chappie"].sample
  end

  def choose
    choice = @@personalities[name].sample
    self.move = Move.new(choice).to_s
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
    puts "Welcome to Rock, Paper, Scissors, Lizard, and Spock #{human.name}!"
    sleep(0.75)
    puts "The game will end when the first player reaches a score of 10."
    sleep(1)
    puts "However, you can quit the game before that."
    puts "\n"
    sleep(1)
  end

  def display_goodbye_message
    if human.score == 10 || computer.score == 10
      puts "One player has reached a score of 10. The game will close down now."
      puts "Goodbye!"
    else
      puts "Thanks for playing Rock, Paper, Scissors, Lizard, and Spock. Bye!"
    end
  end

  def determine_winner(humans_choice, computers_choice)
    losing_moves = Move::RULES_OF_RPS[humans_choice]
    if humans_choice == computers_choice
      "Nobody"
    elsif losing_moves.include?(computers_choice)
      human.name
    else
      computer.name
    end
  end

  def update_score(winner)
    if winner == human.name
      human.score += 1
    elsif winner == computer.name
      computer.score += 1
    end
  end

  def display_winner(winner)
    display_moves
    pause_for_calculation
    display_results(winner)
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    sleep(0.75)
    puts "#{computer.name} chose: #{computer.move}."
    sleep(0.75)
  end

  def pause_for_calculation
    puts "\n-- Calculating --"
    sleep(0.75)
  end

  def display_results(winner)
    puts "\n#{winner} won!"
    sleep(1)
    puts "\n#{human.name} score: #{human.score}"
    puts "#{computer.name}'s score: #{computer.score}"
  end

  def display_move_history(human, computer)
    puts "\n-- MOVES --"
    (0...human.move_history.size).each do |idx|
      puts "Round #{idx + 1}"
      puts "#{human.name}: #{human.move_history[idx]} | " \
           "#{computer.name}: #{computer.move_history[idx]}"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "\nWould #{human.name} like to play again?(y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end

    return true if answer == 'y'
    false
  end

  def play_round
    human_choice = human.choose
    computer_choice = computer.choose
    Player.add_moves_to_players_history(human, human_choice, computer,
                                        computer_choice)
    winner = determine_winner(human_choice, computer_choice)
    update_score(winner)
    display_winner(winner)
    display_move_history(human, computer)
  end

  def game_over?
    computer.score == 10 || human.score == 10
  end

  def play
    display_welcome_message

    loop do
      play_round
      break if game_over?
      break unless play_again?
    end

    display_goodbye_message
  end
end

RPSGame.new.play
