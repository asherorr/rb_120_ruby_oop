class Deck

  attr_reader :cards

  def initialize
    @cards = make_deck_of_cards
  end

  def make_deck_of_cards
    ranks = ["Ace", 2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King"]
    suits = ["♠", "♣", "♥", "♦︎"]

    ranks.product(suits).map { |rank, suit| Card.new(rank, suit) }
  end
end

class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end
  
  def value_of_card(hand_value)
    face_cards = ["Jack", "Queen", "King"]
    value = 0
  
    if face_cards.include?(rank)
      value += 10
    elsif rank == "Ace" # handles updating the value of an ace
      value += determine_ace_value(hand_value)
    else
      value += rank
    end
  
    value
  end

  def determine_ace_value(hand_value)
    if (hand_value + 11) <= 21
      11
    else
      1
    end
  end
end

class Participant
  attr_accessor :hand, :hand_value

  def initialize
    @hand = []
    @hand_value = 0
  end

  def hit(deck)
    cards = deck.cards
    hand << cards.pop
    self.update_hand_value
  end

  def stay
  end

  def busted?
    hand_value > 21
  end

  def update_hand_value
    self.hand_value = 0
    hand.each do |card|
      self.hand_value += card.value_of_card(hand_value)
    end
    hand_value
  end

  def show_hand
    hand.each {|card| puts card}
  end

  def most_recently_drawn_card
    hand[-1]
  end
end

class Player < Participant
  def initialize
    super
  end
end

class Dealer < Participant
  def initialize
    super
  end

  def deal_card
  end
end

class Game

  attr_accessor :winner, :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
    @winner = nil
  end

  def welcome_message
    puts "=========================================="
    puts "||                                      ||"
    puts "||     WELCOME TO 21: THE CARD GAME!    ||"
    puts "||                                      ||"
    puts "=========================================="
    puts "Get ready to test your luck and skill!"
    puts "Can you beat the dealer and score 21?"
    puts ""
    sleep (2.5)
  end


  def play_game
    welcome_message
    loop do
      deal_first_cards!
      show_initial_cards
      show_hand_values
      play_remainder_of_game
      determine_winner
      display_result
      break unless play_again?
      reset_game
    end
    goodbye_message
  end

  def play_remainder_of_game
    player_turn
    dealer_turn unless player.busted? || dealer.hand_value > player.hand_value
  end

  def determine_winner
    if player.busted?
      self.winner = "dealer"
    elsif dealer.busted?
      self.winner = "player"
    elsif player.hand_value == dealer.hand_value
      self.winner = nil
    else
      self.winner = "dealer" if dealer.hand_value > player.hand_value
      self.winner = "player" if player.hand_value > dealer.hand_value
    end
  end

  def deal_first_cards!
    cards = deck.cards
    cards.shuffle!

    2.times {|_| player.hand << cards.pop }
    player.update_hand_value

    2.times {|_| dealer.hand << cards.pop }
    dealer.update_hand_value
  end

  def show_initial_cards
    puts "The player's first two cards are:"
    player.show_hand
    puts "--"
    puts "The dealer's first two cards are: "
    dealer.show_hand
  end

  def show_hand_values
    puts "\nYour hand value: #{player.hand_value} || Dealer's hand value: #{dealer.hand_value}"
  end

  def clear_screen
    system 'clear'
  end

  def show_drawn_card(player)
    puts "-- Drawing Card --"
    sleep (1.5)
    puts "Card drawn: #{player.most_recently_drawn_card}."
  end

  def show_new_hand(player)
    puts "\nNew hand: "
    puts "--"
    player.show_hand
    show_hand_values
  end

  def player_turn
    loop do
      answer = choose_to_hit_or_stay
      clear_screen
      if answer == "hit"
        player.hit(deck)
        show_drawn_card(player)
        show_new_hand(player) unless player.busted?
        break if player.busted?
      else
        break
      end
    end
  end

  def dealer_turn
    clear_screen
    puts "\n-- Dealer's Turn --"
    sleep 1.5

    loop do
      if dealer.hand_value < 17
        dealer.hit(deck)
        show_drawn_card(dealer)
        break if dealer.busted?
      else
        break
      end
    end
  end

  def choose_to_hit_or_stay
    answer = ""
  
    loop do
      valid_options = ["hit", "stay"]
      puts "\nHit or stay?"
      answer = gets.chomp.downcase
      break if valid_options.include?(answer)
      puts "That is not a valid option. Try again."
    end
  
    answer
  end

  def display_result
    show_hand_values
    puts "--"
    if player.busted?
      puts "Because you busted, the winner is the #{winner}!"
    elsif dealer.busted?
      puts "Because the dealer busted, you are the winner!"
    elsif self.winner == nil
      puts "It's a tie!"
    else
      puts "The winner is: #{winner}!"
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

  def reset_game
    self.deck = Deck.new               # Reset the deck
    player.hand = []                   # Clear player's hand
    player.hand_value = 0              # Reset player's hand value
    dealer.hand = []                   # Clear dealer's hand
    dealer.hand_value = 0              # Reset dealer's hand value
    self.winner = nil                  # Reset winner
    clear_screen                       # Optional: clear the screen for the new game
    puts "The game has been reset. Let's play again!\n\n"
    sleep (2)
  end
  
  def goodbye_message
    clear_screen
    puts "=========================================="
    puts "||                                      ||"
    puts "||      THANK YOU FOR PLAYING 21!       ||"
    puts "||                                      ||"
    puts "=========================================="
    puts "Goodbye, and see you soon!"
    puts
  end
end

Game.new.play_game