module Hand
end

class Deck
  def initialize
    @deck_of_cards = make_deck_of_cards
  end

  def make_deck_of_cards
    ranks = ["Ace", 2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King"]
    suits = ["♠", "♣", "♥", "♦︎"]

    ranks.product(suits).map { |rank, suit| Card.new(rank, suit) }
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
  # what goes in here? all the redundant behaviors from Player and Dealer?
end

class Player
  def initialize
    # what would the "data" or "states" of a Player object entail?
    # maybe cards? a name?
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

class Dealer
  def initialize
    # seems like very similar to Player... do we even need this?
  end

  def deal
    # does the dealer or the deck deal?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
  end
end

class Game
  def start
    deal_cards
    show_initial_cards
    player_turn
    dealer_turn
    show_result
  end
end

Game.new.start