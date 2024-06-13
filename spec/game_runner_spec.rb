# spec/game_runner_spec.rb

require 'socket'
require_relative '../lib/game_runner'
require_relative 'server_spec'
require 'game'

RSpec.describe GameRunner do
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

  let(:client1) { Client.new(@server.port_number) }
  let(:client2) { Client.new(@server.port_number) }

  before do
    @clients.push(client1)
    @server_client1 = @server.accept_new_client
    @clients.push(client2)
    @server_client2 = @server.accept_new_client
    client1.provide_input('Gabriel')
    client2.provide_input('Lucas')
    @server.request_names
    @game = @server.create_game_if_possible
    @game_runner = @server.runner(@game)
  end

  describe '#run_loop' do
    it 'should make current_player draw cards if their hand is empty' do
      @game.current_player.hand = []
      @game_runner.run_loop
      expect(@game.current_player.hand.count).not_to eq 0
    end
  end
end