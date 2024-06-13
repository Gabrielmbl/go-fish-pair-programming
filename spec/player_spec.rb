require_relative '../lib/player'
require_relative '../lib/card'

RSpec.describe Player do
  let(:player) { Player.new('Gabriel') }
  let(:card1) { Card.new('2', 'Hearts') }

  describe '#initialize' do
    it 'should respond to name, hand, and books' do
      expect(player).to respond_to(:name)
      expect(player).to respond_to(:hand)
      expect(player).to respond_to(:books)
    end
  end

  describe '#add_to_hand' do
    it 'should add a card to the player hand' do
      expect(player.hand).to be_empty
      player.add_to_hand(card1)
      expect(player.hand).to eq [card1]
    end
  end
end