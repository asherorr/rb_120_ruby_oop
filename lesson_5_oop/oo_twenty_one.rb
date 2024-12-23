# frozen_string_literal: true

module Game_Messages
  def welcome_message(player, dealer)
    clear_screen
    lines = [
      '==========================================',
      '||                                      ||',
      '||     WELCOME TO 21: THE CARD GAME!    ||',
      '||                                      ||',
      '==========================================',
      "Get ready to test your luck and skill, #{player.name}!",
      "Can you beat the dealer, #{dealer.name}, and score 21?",
      '',
      'Press Enter to continue...'
    ]
  
    lines.each { |line| puts line; sleep(0.5) }
    gets.chomp  # Wait for the player to press Enter
    sleep(1)
  end

  def deal_initial_cards_animation(player, dealer)
    num = 1
    2.times do
      clear_screen
      puts "Dealing card #{num} to #{player.name}..."
      sleep(1.5)
      clear_screen
      puts "Dealing card #{num} to #{dealer.name}..."
      sleep(1.5)
      num += 1
    end
    clear_screen
  end

  def announce_that_someone_won
    clear_screen
    border = "=" * 41
    puts border
    puts "||                                      ||"
    puts "||         WE HAVE A WINNER!            ||"
    puts "||                                      ||"
    puts "||                                      ||"
    puts border
    sleep(3)
  end

  def flashing_draw_card_message(message = "Drawing card", duration: 3, interval: 0.5)
    clear_screen
    end_time = Time.now + duration
    while Time.now < end_time
      (1..3).each do |dots|
        clear_screen
        puts "#{message}#{'.' * dots}"
        sleep(interval)
      end
    end
    clear_screen
  end

  def goodbye_message(player)
    clear_screen
    puts '=========================================='
    puts '||                                      ||'
    puts '||      THANK YOU FOR PLAYING 21!       ||'
    puts '||                                      ||'
    puts '=========================================='
    puts "Goodbye #{player.name}, and see you soon!"
    puts
  end
end

# The Deck class represents a standard deck of playing cards.
# It initializes with a full set of cards and includes a method to
# generate the deck and shuffle it.
class Deck

  attr_reader :cards

  private

  def initialize
    @cards = make_deck_of_cards_and_shuffle
  end

  def make_deck_of_cards_and_shuffle
    ranks = ['Ace', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King']
    suits = ['♠', '♣', '♥', '♦︎']

    deck = ranks.product(suits).map { |rank, suit| Card.new(rank, suit) }
    deck.shuffle!
  end
end

# The Card class represents a single playing card with a rank and suit.
# It includes methods for displaying the card as a string and calculating
# its value within the context of a game.
class Card
  attr_reader :rank, :suit

  def to_s
    "#{rank} of #{suit}"
  end

  def determine_ace_value(hand_value)
    if (hand_value + 11) <= 21
      11
    else
      1
    end
  end

  def value_of_card(hand_value)
    face_cards = %w[Jack Queen King]
    value = 0

    value += if face_cards.include?(rank)
               10
             elsif rank == 'Ace' # handles updating the value of an ace
               determine_ace_value(hand_value)
             else
               rank
             end

    value
  end

  private

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
end

# The Participant class serves as a base class for both the Player and Dealer.
# It manages a hand of cards and includes methods for drawing cards, checking if
# the participant has busted, and calculating hand values.
class Participant
  attr_accessor :hand, :hand_value
  attr_reader :player_type, :name

  def hit(deck)
    cards = deck.cards
    hand << cards.pop
    update_hand_value
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
    hand.each { |card| puts card }
  end

  def most_recently_drawn_card
    hand[-1]
  end

  private

  def initialize(player_type=:player)
    @hand = []
    @hand_value = 0
    @player_type = player_type
    @name = get_name
  end

  def get_name
    return ["R2D2", "Chappie", "Wall-E"].sample if self.player_type == :computer
  
    loop do
      puts "Enter your name (must include at least one letter):"
      name = gets.chomp.strip
      return name if name.match?(/[a-zA-Z]/)
  
      puts "Invalid name. It must include at least one alphabetical character. Please try again."
    end
  end
end

class Player < Participant
end

class Dealer < Participant
end

# The Game class orchestrates the flow of the game of 21.
# It manages the deck, player, and dealer, and contains the logic for
# gameplay, including dealing cards, determining the winner, and handling
# player and dealer turns.
class Game
  include Game_Messages

  def play_game
    welcome_message(player, dealer)
    loop do
      deal_first_cards!
      show_initial_cards
      show_hand_values
      play_remainder_of_game
      determine_winner
      announce_that_someone_won
      display_result
      break unless play_again?

      reset_game
    end
    goodbye_message(player)
  end

  private

  attr_accessor :winner, :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new(:computer)
    @winner = nil
  end

  def play_remainder_of_game
    player_turn
    dealer_turn unless player.busted? || dealer.hand_value > player.hand_value || dealer.hand_value == 21
  end

  def determine_winner
    self.winner = if player.busted?
                    dealer.name
                  elsif dealer.busted?
                    player.name
                  elsif player.hand_value == dealer.hand_value
                    nil
                  else
                    determine_winner_by_hand_value
                  end
  end

  def determine_winner_by_hand_value
    dealer.hand_value > player.hand_value ? dealer.name : player.name
  end

  def deal_first_cards!
    deal_initial_cards_animation(player, dealer)
    deal_first_two_cards_to(player)
    deal_first_two_cards_to(dealer)
  end

  def deal_first_two_cards_to(participant)
    2.times { participant.hand << deck.cards.pop }
    participant.update_hand_value
  end

  def show_initial_cards
    puts "#{player.name}'s first two cards are:"
    player.show_hand
    puts '--'
    puts "#{dealer.name}'s first two cards are: "
    dealer.show_hand
  end

  def show_hand_values
    puts "\nYour hand value: #{player.hand_value} || Dealer's hand value: #{dealer.hand_value}"
  end

  def clear_screen
    system 'clear'
  end
  
  def display_drawn_card(player)
    flashing_draw_card_message
    puts "Card drawn: #{player.most_recently_drawn_card}."
  end

  def show_new_hand(player)
    puts "\n#{player.name}'s new hand: "
    puts '--'
    player.show_hand
  end

  def hit_and_display_card_and_hand(player)
    player.hit(deck)
    display_drawn_card(player)
    sleep(2)
    unless player.busted?
      show_new_hand(player) 
      show_hand_values
      sleep(3)
    end
  end

  def player_turn
    loop do
      answer = choose_to_hit_or_stay
      clear_screen
      break unless answer == 'hit'
      
      hit_and_display_card_and_hand(player)
      break if player.busted?
    end
  end

  def should_dealer_hit?
    if dealer.hand_value < 17 && (player.hand_value > dealer.hand_value)
      true
    elsif dealer.hand_value == 21
      false
    elsif dealer.hand_value > 18
      false
    end
  end

  def dealer_turn
    clear_screen
    puts "-- #{dealer.name}'s turn --"
    sleep 1.5

    loop do
      break if should_dealer_hit? == false

      hit_and_display_card_and_hand(dealer)
      sleep 3.5
      break if dealer.busted?
    end
  end

  def choose_to_hit_or_stay
    answer = ''

    loop do
      valid_options = %w[hit stay]
      puts "\nHit or stay?"
      answer = gets.chomp.downcase
      break if valid_options.include?(answer)

      puts 'That is not a valid option. Try again.'
    end

    answer
  end

  def display_result
    show_hand_values
    puts '--'
    if player.busted?
      puts "Because #{player.name} busted, the winner is #{winner}!"
    elsif dealer.busted?
      puts "Because #{dealer.name} busted, #{winner} is the winner!"
    elsif winner.nil?
      puts "The winner is nobody - it's a tie!"
    else
      puts "The winner is #{winner}!"
    end
    sleep (1.5)
  end

  def play_again?
    sleep (1.5)
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
    sleep(2.5)
  end
end

Game.new.play_game
