
class Card
  attr_reader :rank, :suit

  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUITS = %w[Hearts Diamonds Clubs Spades].freeze

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  
end