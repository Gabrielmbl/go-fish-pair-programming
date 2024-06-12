require_relative '../lib/deck'
require_relative '../lib/game'

RSpec.describe Deck do
  let(:deck) { Deck.new }
  describe '#shuffle' do
    it 'should shuffle the deck' do
      original_deck = deck.cards.dup
      deck.shuffle
      expect(deck.cards).not_to eq original_deck
    end
  end

  describe '#populate_deck' do
    it 'should populate deck' do
      deck.populate_deck
      expect(deck.cards.count).to eq Game::DECK_SIZE
    end

    fit 'should populate deck with card objects' do
      deck.populate_deck
      expect(deck.cards.first).to respond_to(:rank)
    end
  end
end
