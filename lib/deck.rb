class Deck
  attr_accessor :cards

  def initialize(cards = [])
    @cards = cards
  end

  def shuffle
  end

  def populate_deck
    Game::DECK_SIZE.times {cards << 'A'}
  end
end