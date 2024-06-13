require_relative '../lib/server'

server = Server.new
server.start
while true
  begin
    client = server.accept_new_client
    next unless client

    server.request_names
    game = server.create_game_if_possible
    server.run_game(game) if game
  rescue StandardError
    server.stop
  end
end
