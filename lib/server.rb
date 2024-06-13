# lib/server.rb
require 'socket'
require_relative 'player'

class Server
  attr_accessor :server, :clients, :players, :games, :available_clients

  def initialize
    @clients = []
    @contacted_clients = []
    @games = []
    @players = {}
    @available_clients = {}
  end

  def port_number
    3336
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def send_message(client, message)
    client.puts(message)
  end

  def capture_output(client, delay = 0.1)
    sleep(delay)
    @output = client.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ''
  end

  def accept_new_client(player_name = 'Random Player')
    client = @server.accept_nonblock
    clients << client
    client
  rescue IO::WaitReadable, Errno::EINTR
    puts 'No client to accept'
  end
  
  def request_names
    clients.each { |client| record_player_name(client) }
  end

  def record_player_name(client)
    return if players[client]

    send_message(client, 'Enter your name:')

    name = capture_output(client).chomp
    return unless name.length.positive?

    game_player = Player.new(name)
    players[client] = game_player
    available_clients[client] = game_player
  end

  def create_game_if_possible
    if players.count >= 2
      create_game
    elsif players.count == 1
      contact_client
    else
      puts 'There are no players'
    end
  end

  def create_game
    puts 'There are enough players to start a game'
    game = Game.new([*available_clients.values])
    available_clients.clear
    games << game
    game
  end

  def contact_client
    puts 'There is only one player'
    return if contacted_clients.first == players.first

    send_message(players.first, 'Waiting for another player to join')
    contacted_clients << players.first
  end

  def run_game(game)
    runner(game).run
  end

  def runner(game)
    clients = game.players.map { |player| players.key(player) }
    game_runner = GameRunner.new(game, clients, self)
  end

  def stop
    @server.close if @server
  end
end
