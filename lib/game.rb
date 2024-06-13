class Game 
  attr_reader :players
  attr_accessor :current_player

  DECK_SIZE = 52

  def initialize(players)
    @players = players
    @current_player = players.first
  end

  def deck
    @deck ||= Deck.new
  end

  def start
    deck.shuffle
  end

end