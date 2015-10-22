require_relative "dictionary.rb"

class AIPlayer < Player
	def initialize(name = 'HAL-3000', dictionary = Dictionary.new)
		@name = name
		@dictionary = dictionary
		@guesses = false
	end

	def select_word
		@dictionary.select_word
	end
end