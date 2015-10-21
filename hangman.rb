require "pry"
require_relative "player.rb"
require_relative "game.rb"

def create_players(players_info)
  players_info.map {|player| Player.new(player[:name], player[:guesses]) }
end

players = create_players(Game.ask_for_players_info)
game = Game.new(players)
game.ask_for_word

while !game.game_over
  game.execute
end