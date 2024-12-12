# frozen_string_literal: true

class Board # rubocop:disable Style/Documentation
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def set_square_at(key, marker)
    @squares[key].marker = marker
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts ''
    puts '     |     |'
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts '     |     |'
    puts '-----+-----+-----'
    puts '     |     |'
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts '     |     |'
    puts '-----+-----+-----'
    puts '     |     |'
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts '     |     |'
    puts ''
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def display_available_squares(delimeter = ", ", word = "or")
    keys = unmarked_keys.dup # Create a copy to avoid modifying the original array.
    if keys.size == 1
      "#{keys[0]}"
    elsif keys.size < 3
      "#{keys[0]} #{word} #{keys[1]}"
    else
      keys[-1] = "#{word} #{keys[-1]}"
      keys.join(delimeter)
    end
  end
  
  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def count_human_marker(squares)
    squares.collect(&:marker).count(TTTGame::HUMAN_MARKER)
  end

  def count_computer_marker(squares)
    squares.collect(&:marker).count(TTTGame::COMPUTER_MARKER)
  end

  # returns winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      return squares.first.marker if three_identical_markers?(squares)
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3

    markers.min == markers.max
  end
end

class Square # rubocop:disable Style/Documentation
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player # rubocop:disable Style/Documentation
  attr_accessor :score
  attr_reader :marker

  def initialize(marker, score=0)
    @marker = marker
    @score = score
  end

  def update_score
    @score += 1
  end
end

class TTTGame # rubocop:disable Style/Documentation
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  FIRST_TO_MOVE = HUMAN_MARKER

  attr_reader :board, :human, :computer

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?

      clear_screen_and_display_board if human_turn?
    end
  end

  def play
    clear_screen
    display_welcome_message
    main_game
    display_goodbye_message
  end

  def play_round_of_game
    display_score
    display_board
    player_move
    display_result
    sleep(2)
    reset_board
  end

  def main_game
    loop do
      until human.score == 5 || computer.score == 5
        play_round_of_game
      end
    break unless play_again?
    reset_scores
    reset_board
    end
  end

  private

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end

  def display_welcome_message
    puts 'Welcome to Tic Tac Toe!'
    puts "\nThe first player to win 5 games is the winner."
    puts ''
  end

  def display_goodbye_message
    puts 'Thanks for playing Tic Tac Toe! Goodbye!'
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    board.draw
  end

  def display_score
    puts "Your score: #{human.score} || Computer's score: #{computer.score}"
    puts ""
  end

  def clear_screen_and_display_board
    clear_screen
    display_board
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def human_moves
    puts "Choose a square: #{board.display_available_squares}"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)

      puts "Sorry, that's not a valid choice."
    end

    board.set_square_at(square, human.marker)
  end

  def computer_moves
    board.set_square_at(board.unmarked_keys.sample, computer.marker)
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts 'You won!'
      human.update_score
    when computer.marker
      puts 'Computer won!'
      computer.update_score
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp.downcase
      break if %w[y n].include? answer

      puts 'Sorry, must be y or n.'
    end

    answer == 'y'
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def clear_screen
    system 'clear'
  end

  def reset_board
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear_screen
  end

  def reset_scores
    human.score = 0
    computer.score = 0
  end
end

game = TTTGame.new
game.play
