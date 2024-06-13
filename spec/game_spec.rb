# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/deck'
require 'spec_helper'

RSpec.describe Game do
  let(:player1) {Player.new('gabriel')}
  let(:player2) {Player.new('lucas')}
  let(:game) {Game.new([player1, player2])}
  let(:card1) {Card.new('2', 'Hearts')}

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

    it 'should deal cards to each player' do
    end
  end

  describe '#draw_if_empty_hand' do
    it 'should not make current_player draw cards if their hand is not empty' do
      player1.hand = [card1]
      game.draw_if_empty_hand
      expect(game.current_player.hand.count).to eq 1
    end
    it 'should make current_player draw cards if their hand is empty' do
      game.current_player.hand = []
      game.draw_if_empty_hand
      expect(game.current_player.hand.count).not_to eq 0
    end
  end
end
