class Game 
  attr_reader :players

  DECK_SIZE = 52

  def initialize(players)
    @players = players
  end

  def deck
    @deck ||= Deck.new
  end

  def start
    deck.shuffle
  end

end