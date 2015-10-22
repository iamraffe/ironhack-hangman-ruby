class Dictionary
	def initialize(dictionary = 'dictionary.txt')
    @dictionary = dictionary
	end

	def select_word
		dictionary = IO.read(@dictionary).split(/\r?\n/)
    target_word = dictionary.sample
    while !is_valid?(target_word)
    	target_word = dictionary.sample
    end
    target_word.split('')
	end

	def is_valid?(word)
		(word.length < 13 && word.length > 4) ? true : false
	end
end