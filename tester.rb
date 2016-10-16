

class Game
	attr_reader :game_word
	def initialize
		@game_word = SecretWord.new.word
	end

	def word_as_dashes
		@game_word.gsub(/./, '_')
	end		
end

class SecretWord
	attr_reader :word
	def initialize
		@word = select_word(open_file)
	end

	private

	def open_file
		f = File.open("words.txt", "r").readlines
		f.sample
	end

	def select_word(word)
		word.strip!
		if word.length < 5 || word.length > 12
			select_word(open_file)
		else
			word
		end
	end
end

word = Game.new
p word.game_word
p word.word_as_dashes