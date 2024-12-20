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

  attr_accessor :winner
  attr_reader :player, :dealer, :deck

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
    @winner = nil
  end

  def start_game
    deal_first_cards!
    player.update_hand_value
    dealer.update_hand_value
    show_initial_cards
    play_remainder_of_game
    display_result
  end

  def play_remainder_of_game
    player_turn
    if player.busted?
      self.winner = "dealer"
    else
      dealer_turn
      self.winner = "player" if dealer.busted?
    end
  end

  def determine_winner
  end

  def deal_first_cards!
    cards = deck.cards
    cards.shuffle!
    2.times {|_| player.hand << cards.pop }
    2.times {|_| dealer.hand << cards.pop }
  end

  def show_initial_cards
    puts "The player's first two cards are:"
    player.show_hand
    puts "--"
    puts "The dealer's first two cards are: "
    dealer.show_hand
  end

  def player_turn
    loop do
      puts "\nYour hand value: #{player.hand_value} || Dealer's hand value: #{dealer.hand_value}"
      answer = choose_to_hit_or_stay
      if answer == "hit"
        player.hit(deck)
        player.update_hand_value
        break if player.busted?
      else
        break
      end
    end
  end

  def dealer_turn
    puts "\n-- Dealer's Turn --"
    sleep 1.5

    loop do
      if dealer.hand_value < 17
        dealer.hit(deck)
        dealer.update_hand_value
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
      puts "Hit or stay?"
      answer = gets.chomp.downcase
      break if valid_options.include?(answer)
      puts "That is not a valid option. Try again."
    end
  
    answer
  end

  def display_result
    if self.winner == nil
      puts "It's a tie!"
    else
      puts "The winner is #{winner}."
    end
  end
end

Game.new.start_game