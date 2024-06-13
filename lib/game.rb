class Game 
  attr_reader :players
  attr_accessor :current_player

  DECK_SIZE = 52
  STARTING_CARD_COUNT = 5

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

  def draw_if_empty_hand
    return unless current_player.hand.empty?

    current_player.add_to_hand([deck.deal]) until deck.cards.empty? || current_player.hand.count == STARTING_CARD_COUNT
  end

end