require_relative '../lib/card'

RSpec.describe Card do
  describe '#initialize' do
    it 'should respond to rank and suit' do
      card = Card.new('2', 'Hearts')
      expect(card).to respond_to(:rank)
      expect(card).to respond_to(:suit)
    end
  end
end