class Player
  attr_reader :name
  attr_accessor :hand, :books

  def initialize(name = 'RandomName', hand: [], books: [])
    @name = name
    @hand = hand
    @books = books
  end

  def add_to_hand(card)
    @hand.unshift(card)
  end
end