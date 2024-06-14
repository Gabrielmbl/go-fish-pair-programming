# spec/game_runner_spec.rb

require 'socket'
require_relative '../lib/game_runner'
require_relative 'server_spec'
require_relative '../lib/game'
require_relative '../lib/card'

RSpec.describe GameRunner do
  before(:each) do
    @clients = []
    @server = Server.new
    @server.start
    sleep 0.1 # ensure server is started
  end

  after(:each) do
    @server.stop
    @clients.each(&:close)
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
    let(:card1) { Card.new('3', 'Hearts') }
    let(:card2) { Card.new('6', 'Clubs') }

    it 'should make current_player draw cards if their hand is empty' do
      @game.current_player.hand = []
      @game_runner.run_loop
      expect(@game.current_player.hand.count).not_to eq 0
    end

    it 'should display current player their hand only once' do
      @game.current_player.hand = [card1, card2]
      @game_runner.run_loop
      expect(client1.capture_output).to include('Your hand is: 3 of Hearts, 6 of Clubs')
      client1.capture_output
      @game_runner.run_loop
      expect(client1.capture_output).not_to include('Your hand is: 3 of Hearts, 6 of Clubs')
    end

    before do
      @game.current_player.hand = [card1]
    end

    it 'should ask client for their move' do
      @game_runner.run_loop
      expect(client1.capture_output).to include("Choose a rank to ask for: \n")
    end

    it 'should store the opponent and rank the client chooses' do
      client1.provide_input('Lucas, 3')
      @game_runner.run_loop
      expect(@server.capture_client_input(@server_client1)).to eq 'Lucas, 3'
    end

    xit 'should tell client to ask for a rank that they already have' do
      client1.provide_input('Lucas, 4')
      @game_runner.run_loop
      expect(client1.capture_output).to include("Ask for a rank that you already have in your hand.\n")
    end
  end
end
