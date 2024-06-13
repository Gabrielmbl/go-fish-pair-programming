# lib/game_runner.rb

require_relative 'game'
require_relative 'server'

class GameRunner

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
  end
end