require 'io/console'

class Game
  attr_reader :game_over

  def initialize(players)
    @player_sets_word = who_sets_word(players)
    @player_guesses = who_guesses(players)
    @game_over = false
    @tries = 0
  end

  def who_sets_word(players)
    players.find{|player| !player.guesses}
  end

  def who_guesses(players)
    players.find{|player| player.guesses}
  end

  def ask_for_word
    puts "#{@player_sets_word.name} what will the word be?"
    @target_word = STDIN.noecho(&:gets).chomp.downcase.split('')
    @guess_bag = @target_word.map{|letter| "_"}
  end

  def print_board
    puts "#{@guess_bag.join(' ')}\n\n-------> TURNS LEFT #{6-@tries}\n\n "
  end

  def turns_left?
    @tries < 6 
  end

  def letters_left?
    @guess_bag.include?('_')
  end

  def word_not_guessed
    @game_over = true
    puts "#{@player_sets_word.name} wins!"
  end

  def word_guessed
    @game_over = true
    puts "#{@player_guesses.name} wins!"
  end

  def update_status
    if !letters_left?  
      word_guessed
    elsif !turns_left?
      word_not_guessed
    end
  end

  def handle_comparison(user_input) 
    if @target_word.include?(user_input)
      @guess_bag.map!.with_index{|letter, index| @target_word[index] == user_input ? user_input : letter}
    else
      @tries+=1
    end
  end

  def handle_turn(user_input)
    handle_comparison(user_input)
    update_status
  end

  def execute
    print_board
    handle_turn(@player_guesses.ask_for_letter)
  end

  def self.ask_for_players_info
    puts "Welcome to hangman!\nWhat is the name of the player who will set the word?"
    first_player = gets.chomp
    puts "Great! What is the name of player that will guess the word?"
    second_player = gets.chomp
    [{name: first_player, guesses: false}, {name: second_player, guesses: true}]
  end
end