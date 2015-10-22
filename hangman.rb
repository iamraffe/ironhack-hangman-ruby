require "pry"
require_relative "player.rb"
require_relative "game.rb"

def create_players(players_info)
  players_info.map {|player| Player.new(player[:name], player[:guesses]) }
end

game_mode = Game.set_mode
players = create_players(Game.ask_for_players_info(game_mode))
game = Game.new(players, game_mode)
game.establish_word

while !game.game_over
  game.execute
end