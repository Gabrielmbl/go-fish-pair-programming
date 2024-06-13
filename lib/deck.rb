class Deck
  attr_accessor :cards

  def initialize(cards = [])
    @cards = populate_deck
  end

  def shuffle
    original_deck = cards.dup
    cards.shuffle! until original_deck != cards
  end

  def populate_deck
    cards = Card::SUITS.flat_map do |suit|
      Card::RANKS.map do |rank|
        Card.new(rank, suit)
      end
    end
  end

  def deal
    cards.pop
  end
end