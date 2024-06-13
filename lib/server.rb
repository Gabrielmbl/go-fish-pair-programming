# lib/server.rb
require 'socket'
require_relative 'player'

class Server
  attr_accessor :server, :clients, :players, :games

  def initialize
    @clients = []
    @players = {}
    @prompted_clients = []
    @games = []
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
    return if name == ''

    game_player = Player.new(name)
    players[client] = game_player
  end

  def create_game_if_possible
    
  end


  def stop
    @server.close if @server
  end
end
