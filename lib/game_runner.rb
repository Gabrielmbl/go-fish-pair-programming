# lib/game_runner.rb

require_relative 'game'
require_relative 'server'

class GameRunner
  attr_reader :game, :clients, :server
  attr_accessor :prompted_players

  def initialize(game, clients, server)
    @game = game
    @clients = clients
    @server = server
    @prompted_players = []
  end

  def run
    game.start

    run_loop until game.game_winner
  end

  def run_loop(game_current_player = game.current_player)
    current_player_client = server.players.key(game_current_player)
    return if game.draw_if_empty_hand

    display_hand(current_player_client)
    ask_for_move(current_player_client)
    
  end

  private

  def display_hand(client)
    return if prompted_players.include?(client)

    hand = game.current_player.hand.map { |card| "#{card.rank} of #{card.suit}" }.join(', ')
    hand_message = "Your hand is: #{hand}"
    server.send_message(client, hand_message)
    prompted_players << client
  end

  def ask_for_move(client)
    server.send_message(client, 'Choose a rank to ask for:')
  end

end