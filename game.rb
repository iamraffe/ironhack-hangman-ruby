require 'io/console'

class Game
  attr_reader :game_over

  def initialize(players, game_mode = 2)
    @player_sets_word = who_sets_word(players)
    @player_guesses = who_guesses(players)
    @game_over = false
    @tries = 0
    @game_mode = game_mode
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
  end

  def ai_set_word
    dictionary = IO.read('dictionary.txt')
    word_array = dictionary.split(/\r?\n/)
    sorted_words = word_array.select{|word| word.length < 13 && word.length > 4}
    @target_word = sorted_words.sample.split('')
  end

  def establish_word
    if @game_mode == 1
      ai_set_word
    else
      ask_for_word
    end
    @guess_bag = @target_word.map{|letter| "_"}
    @used_letters = []
  end

  def print_board
    puts "\n\n#{@guess_bag.join(' ')}\n\n-------> TRIES LEFT #{6-@tries}\n\nUSED LETTERS: #{@used_letters.join(' ')}\n\n "
  end

  def turns_left?
    @tries < 6 
  end

  def letters_left?
    @guess_bag.include?('_')
  end

  def word_not_guessed
    @game_over = true
    puts "The word was: #{@target_word.join('')}\n#{@player_sets_word.name} wins!"
  end

  def word_guessed
    @game_over = true
    puts "The word was: #{@target_word.join('')}\n#{@player_guesses.name} wins!"
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
    @used_letters.push(user_input)
    handle_comparison(user_input)
    update_status
  end

  def execute
    print_board
    handle_turn(@player_guesses.ask_for_letter)
  end

  # def print_mode_menu
  #   puts "Welcome to hangman!\nSelect the play mode:\n1. Single Player\n2. Multiplayer\n\n"
  # end

  def self.set_mode
    puts "Welcome to hangman!\nSelect the play mode:\n1. Single Player\n2. Multiplayer\n\n"
    game_mode = gets.chomp.to_i
  end

  def self.single_player_mode
    puts "Oh man, you will be playing against HAL-3000\nGood luck... I mean, what is your name?"
    player_name = gets.chomp
    [{name: player_name, guesses: true}, {name: 'HAL-3000', guesses: false}]
  end

  def self.multiplayer_mode
    puts "What is the name of the player who will set the word?"
    first_player = gets.chomp
    puts "Great! What is the name of player that will guess the word?"
    second_player = gets.chomp
    [{name: first_player, guesses: false}, {name: second_player, guesses: true}]
  end

  def self.ask_for_players_info(game_mode)
    case game_mode
      when 1
        self.single_player_mode
      when 2
        self.multiplayer_mode
      else
        puts "You suck"
    end
  end
end