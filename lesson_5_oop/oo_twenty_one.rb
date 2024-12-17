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
end

class Participant
  attr_accessor :hand

  def initialize
    @hand = []
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
    # definitely looks like we need to know about "cards" to produce some total
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

  attr_reader :player, :dealer, :deck

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    deal_first_cards
    show_initial_cards
    player_turn
    dealer_turn
    show_result
  end

  def deal_first_cards
    cards = deck.cards
    cards.shuffle!
    2.times {|_| player.hand << cards.pop }
    2.times {|_| dealer.hand << cards.pop }
  end
end

Game.new.start