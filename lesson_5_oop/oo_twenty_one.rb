# frozen_string_literal: true

# The Utilty module contains a method to clear the screen
module Utility
  def clear_screen
    system 'clear' or system 'cls'
  end
end

module WinningScore
  TARGET_SCORE = 21
end

# The GameMessages module contains methods for displaying messages and animations
# during the game. These include welcom e and goodbye messages, card dealing animations,
# winner announcements, and dynamic prompts to enhance the user experience.
module GameMessages
  def animate(lines, delay: 0.5)
    lines.each do |line|
      puts line
      sleep(delay)
    end
  end

  def welcome_message(player, dealer)
    clear_screen
    messages = [
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
    animate(messages, delay: 0.4)
    gets.chomp
  end

  def deal_initial_cards_animation(player, dealer)
    2.times do |num|
      clear_screen
      puts "Dealing card #{num + 1} to #{player.name}..."
      sleep(1.5)
      clear_screen
      puts "Dealing card #{num + 1} to #{dealer.name}..."
      sleep(1.5)
    end
    clear_screen
  end

  def announce_that_someone_won
    clear_screen
    border = '=' * 42
    puts border
    puts '||                                      ||'
    puts '||         WE HAVE A WINNER!            ||'
    puts '||                                      ||'
    puts '||                                      ||'
    puts border
    sleep(3)
  end

  def flashing_draw_card_message(message = 'Drawing card', duration: 3, interval: 0.5)
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
    animation_lines = [
      '==========================================',
      '||                                      ||',
      '||      THANK YOU FOR PLAYING 21!       ||',
      '||                                      ||',
      '==========================================',
      "Goodbye #{player.name}, and see you soon!"
    ]
    animate(animation_lines)
  end
end

# The Deck class represents a deck of playing cards.
# It initializes with a shuffled standard 52-card deck.
# This class encapsulates the logic for creating and shuffling the deck.
class Deck
  RANKS = ['Ace', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King'].freeze
  attr_reader :cards

  private

  def initialize
    @cards = make_deck
  end

  def make_deck
    suits = ['♠', '♣', '♥', '♦︎']

    deck = RANKS.product(suits).map { |rank, suit| Card.new(rank, suit) }
    deck.shuffle!
  end
end

# The Card class represents an individual playing card with a rank and suit.
# It provides methods to display the card and calculate its value in a game of 21,
# including dynamic handling of Ace values based on the current hand value.
class Card
  include WinningScore

  attr_reader :rank, :suit

  def to_s
    "#{rank} of #{suit}"
  end

  def determine_ace_value(hand_value)
    if (hand_value + 11) <= TARGET_SCORE
      11
    else
      1
    end
  end

  def value(hand_value)
    face_cards = %w[Jack Queen King]

    if face_cards.include?(rank)
      10
    elsif rank == 'Ace' # handles updating the value of an ace
      determine_ace_value(hand_value)
    else
      rank
    end
  end

  private

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
end

# The Participant class is a base class for both the Player and Dealer.
# It manages a hand of cards, calculates hand values, determines if the participant has busted,
# and includes common behaviors like hitting and displaying cards.
class Participant
  include GameMessages
  include Utility
  include WinningScore

  attr_accessor :hand, :hand_value
  attr_reader :player_type, :name

  def hit(deck)
    cards = deck.cards
    hand << cards.pop
    update_hand_value
  end

  def hit_and_display_card(deck)
    hit(deck)
    display_drawn_card
    sleep(1.5)
    return if busted?
  end

  def busted?
    hand_value > TARGET_SCORE
  end

  def update_hand_value
    self.hand_value = 0
    hand.each do |card|
      self.hand_value += card.value(hand_value)
    end
    hand_value
  end

  def show_each_card_in_hand
    puts "#{name}'s hand: "
    puts '--'
    hand.each { |card| puts card }
    puts ''
  end

  def most_recently_drawn_card
    hand[-1]
  end

  def display_drawn_card
    flashing_draw_card_message
    puts "Card drawn: #{most_recently_drawn_card}."
    puts ''
  end

  private

  def initialize(player_type = :player)
    @deck = Deck.new
    @hand = []
    @hand_value = 0
    @player_type = player_type
    @name = assign_name
  end

  def assign_name
    return %w[R2D2 Chappie Wall-E].sample if player_type == :computer

    loop do
      puts 'Enter your name (must include at least one letter):'
      name = gets.chomp.strip
      return name if name.match?(/[a-zA-Z]/)

      puts 'Invalid name. It must include at least one alphabetical character. Please try again.'
    end
  end
end

# The Player class inherits from Participant and represents the human player.
# It provides methods for the player's turn, including the option to hit or stay,
# and displays the current state of their hand and its value.
class Player < Participant
  def turn(deck, opponent)
    loop do
      answer = choose_to_hit_or_stay
      clear_screen
      break unless answer == 'hit'

      hit_and_display_card(deck)
      show_each_card_in_hand
      puts "Your hand value: #{self.hand_value}"
      puts "#{opponent.name}'s hand value: #{opponent.hand_value}"
      break if busted?
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
end

# The Dealer class inherits from Participant and represents the computer dealer.
# It includes logic specific to the dealer's actions, such as deciding when to hit
# and dealing the initial cards to both players. The dealer follows specific rules
# for gameplay, such as always hitting on a hand value less than 17.
class Dealer < Participant
  include GameMessages

  def deal_first_cards!(player, dealer, deck)
    deal_initial_cards_animation(player, dealer)
    deal_first_two_cards_to(player, deck)
    deal_first_two_cards_to(dealer, deck)
  end

  def deal_first_two_cards_to(participant, deck)
    2.times { participant.hand << deck.cards.pop }
    participant.update_hand_value
  end

  def turn(deck)
    clear_screen
    puts "-- #{name}'s turn --"
    sleep 1.5

    loop do
      break if should_dealer_hit? == false

      hit_and_display_card(deck)
      sleep 2.5
      break if busted?
    end
  end

  def should_dealer_hit?
    self.hand_value < 17
  end
end

# The Game class orchestrates the overall flow of the game of 21.
# It handles the setup of players and the deck, the turn-based gameplay, determining the winner,
# and prompting the user to play again or exit. This class is the main entry point for the game.
class Game
  include GameMessages
  include Utility
  include WinningScore

  def start_game
    welcome_message(player, dealer)
    loop do
      play_round_of_game
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

  def play_round_of_game
    dealer.deal_first_cards!(player, dealer, deck)
    show_both_players_hands
    show_hand_values
    execute_player_and_dealer_turn(deck)
    determine_winner
    announce_that_someone_won
    display_result
  end

  def show_both_players_hands
    player.show_each_card_in_hand
    dealer.show_each_card_in_hand
  end

  def show_hand_values
    puts "#{player.name}'s hand value: #{player.hand_value} || #{dealer.name}'s hand value: #{dealer.hand_value}"
  end

  def execute_player_and_dealer_turn(deck)
    player.turn(deck, dealer)
    dealer.turn(deck) unless player.busted? || dealer.hand_value > player.hand_value || dealer.hand_value == TARGET_SCORE
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

  def result_message
    if player.busted?
      "Because #{player.name} busted, the winner is #{winner}!"
    elsif dealer.busted?
      "Because #{dealer.name} busted, #{winner} is the winner!"
    elsif winner.nil?
      "The winner is nobody - it's a tie!"
    else
      "The winner is #{winner}!"
    end
  end

  def display_result
    show_hand_values
    puts '--'
    puts result_message
  end

  def play_again?
    sleep(2.5)
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

Game.new.start_game
