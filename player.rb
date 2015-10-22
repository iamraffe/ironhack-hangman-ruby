class Player
  attr_reader :name, :guesses

  def initialize(name, guesses = true)
    @name = name
    @guesses = guesses
  end

  def select_word
    puts "#{@name} what will the word be?"
    STDIN.noecho(&:gets).chomp.downcase.split('')
  end

  def ask_for_letter
    puts "Gimme a letter #{name}"
    letter = gets.chomp
    letter
  end
end
