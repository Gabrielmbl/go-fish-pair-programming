# lib/game_runner.rb

require_relative 'game'
require_relative 'server'

class GameRunner
  attr_reader :game, :clients, :server

  def initialize(game, clients, server)
    @game = game
    @clients = clients
    @server = server
  end

  def run
    game.start

    run_loop until game.game_winner
  end

  def run_loop
    return if game.draw_if_empty_hand
  end
end