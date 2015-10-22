require "pry"
require_relative "player.rb"
require_relative "game.rb"
require_relative "aiplayer.rb"

def establish_game_mode
  puts "Welcome to hangman!\nSelect the play mode:\n1. Single Player\n2. Multiplayer\n\n"
  gets.chomp.to_i
end

def single_player_mode
  puts "Oh man, you will be playing against HAL-3000\nGood luck... I mean, what is your name?"
  player_name = gets.chomp
  [Player.new(player_name, true), AIPlayer.new]
end

def multiplayer_mode
  puts "What is the name of the player who will set the word?"
  first_player = gets.chomp
  puts "Great! What is the name of player that will guess the word?"
  second_player = gets.chomp
  [Player.new(first_player, false), Player.new(second_player, true)]
end

def establish_players(game_mode)
  case game_mode
    when 1
      players = single_player_mode
    when 2
      players = multiplayer_mode
    else
      puts "You suck"
  end
 	players
end

game_mode = establish_game_mode
players = establish_players(game_mode)
game = Game.new(players)
game.play
