require 'io/console'

class Game
  def initialize(players, target_word = [], guess_bag = [], tries = 0, used_letters = [])
    @player_sets_word = who_sets_word(players)
    @player_guesses = who_guesses(players)
    @game_over = false
    @tries = tries
    @used_letters = used_letters
    @guess_bag = guess_bag
    @target_word = target_word
  end

  def who_sets_word(players)
    players.find{|player| !player.guesses}
  end

  def who_guesses(players)
    players.find{|player| player.guesses}
  end

  def ask_for_word
    @target_word = @player_sets_word.select_word
  end

  def establish_word
    ask_for_word
    @guess_bag = @target_word.map{|letter| "_"}
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

  def save_game?
    puts "\nDo you wish to save the current game?\n\n1. Yes\n2. No\n"
    gets.chomp.to_i == 1 ? true : false
  end

  def ask_for_filename
    puts "Give me the name of the file you wish to save the game\n "
    filename = gets.chomp
    filename
  end

  def prepare_variables
    {player_sets_word: @player_sets_word, player_guesses: @player_guesses, tries: @tries, used_letters: @used_letters, guess_bag: @guess_bag, target_word: @target_word}
  end

  def write_to_file(game_variables, filename)
    game_variables.each do |key, vals|
      File.open(filename, 'a') { |f| f.write("#{key}: #{vals}\n") }
      # File.open("#{key}.txt", 'w') { |file| file.puts *vals }
    end
  end

  def save_game
    filename = ask_for_filename
    binding.pry
    game_variables = prepare_variables
    write_to_file(game_variables, filename)
    @game_over = true
    puts "Game saved for later!"
  end

  def handle_turn(user_input)
    @used_letters.push(user_input)
    handle_comparison(user_input)
    update_status
  end

  def execute
    print_board
    if save_game?
      save_game
    else
      handle_turn(@player_guesses.ask_for_letter)
    end
  end

  def play
    establish_word
    while !@game_over
      execute
    end
  end
end