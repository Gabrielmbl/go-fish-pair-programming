# spec/server_spec.rb

require 'socket'
require_relative '../lib/server'
require 'game'
require 'client'

class MockClient
  attr_reader :socket, :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def send_message(text)
    @socket.puts(text)
  end

  def capture_output(delay = 0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000)
  rescue IO::WaitReadable
    @output = ''
  end

  def capture_input(delay = 0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ''
  end

  def close
    @socket.close if @socket
  end
end

RSpec.describe Server do
  before(:each) do
    @clients = []
    @server = Server.new
    @server.start
    sleep 0.1 # ensure server is started
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  it 'is not listening on a port before it is started' do
    @server.stop
    expect { Client.new(@server.port_number) }.to raise_error(Errno::ECONNREFUSED)
  end

  describe '#accept_new_client' do
    it 'should add a client to the clients array' do
      Client.new(3336)
      expect(@server.clients).to be_empty
      @server.accept_new_client
      expect(@server.clients.count).to eq 1
    end
  end

  describe '#record_player_name' do

    before do
      @client = Client.new(3336)
      @client_server = @server.accept_new_client
    end

    it 'should prompt client to give their name' do
      @server.record_player_name(@client_server)
      expect(@client.capture_output).to eq('Enter your name:')
    end

    it 'should map client to player object' do
      expect(@server.players).to be_empty
      @client.provide_input('Gabriel')
      @server.record_player_name(@client_server)
      expect(@server.players[@client_server]).to respond_to(:name)
    end

    it 'should only create player object if client has sent a name' do
      @server.record_player_name(@client_server)
      expect(@server.players[@client_server]).to be_nil
    end
  
  end

  describe '#create_game_if_possible' do
    it 'should not create a game if there are not enough players' do
      expect(@server.games.count).to eq 0
      @server.create_game_if_possible
      expect(@server.games.count).to eq 0
    end

    before do
      @client1 = Client.new(3336)
      @client_server1 = @server.accept_new_client
      @client2 = Client.new(3336)
      @client_server2 = @server.accept_new_client
      @client1.provide_input('Gabriel')
      @client2.provide_input('Lucas')
      @server.request_names
      binding.irb
    end
    it 'should create a game if there are enough players' do

    end
  end
end
