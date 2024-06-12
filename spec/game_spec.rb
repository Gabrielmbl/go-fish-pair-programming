# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/deck'
require 'spec_helper'

RSpec.describe Game do
  let(:player1) {Player.new('gabriel')}
  let(:player2) {Player.new('lucas')}
  let(:game) {Game.new([player1, player2])}

  describe '#initialize' do
    it 'should respond to players' do
      expect(game).to respond_to(:players)
    end

    it 'should respond to deck' do
      expect(game).to respond_to(:deck)
    end
  end

  describe '#start' do
    it 'should shuffle the deck' do
      expect(game.deck).to receive(:shuffle).once
      game.start
    end
  end
end
