require 'sinatra'
require 'sinatra/reloader' if development?

enable :sessions

get '/' do
	if session[:completed_game] == true || session[:game_word].nil?
		session.clear
		redirect to ('/newgame') 
	end	

	erb :index
end

get '/newgame' do
	new_game

	redirect to ('/')
end

post '/guess' do
	@guess = params["guess"].downcase

	process_guess(@guess)

	redirect to ('/win') if win?
	redirect to ('/lose') if lose?

	redirect to ('/')
end

get '/win' do
	session[:completed_game] = true

	erb :win
end

get '/lose' do
	session[:completed_game] = true

	erb :lose
end

helpers do
	def new_game
		game_word = SecretWord.new
		session[:game_word] = game_word.word
		session[:completed_game] = false
		session[:word_as_dashes] = game_word.word_as_dashes
		session[:guesses_left] = 8
		session[:guessed] = Array.new
		session[:incorrect_guesses] = Array.new
		session[:test_value] = "In Treatment"
	end

	def process_guess(guess)
		game_word_array = session[:game_word].split("")
		if session[:game_word].include?(guess) && !session[:guessed].include?(guess) && guess.length == 1
			guess_matches = game_word_array.each_index.select {|letter| game_word_array[letter] == guess}
			guess_matches.each{|match| session[:word_as_dashes][match] = guess}
			session[:game_message] = guess_matches.size == 1 ? "There is 1 #{guess.upcase}" : "There are #{guess_matches.size} #{guess.upcase}\'s"
			session[:guessed] << guess
		else
			handle_invalid_guess(guess)
		end
	end

	def handle_invalid_guess(guess)
		if !(guess =~ /[a-z]/)
			session[:game_message] = "Only letters are valid guesses."
		elsif guess.length == 0
			session[:game_message] = "You didn\'t register a guess."
		elsif guess.length != 1
			session[:game_message] = "You can only enter one character at a time"
		elsif session[:guessed].include?(guess)
			session[:game_message] = "You have already guessed that letter."
			session[:guesses_left] -= 1
		elsif !session[:game_word].include?(guess)
			session[:game_message] = "There are no #{guess.upcase}\'s"
			session[:guessed] << guess
			session[:guesses_left] -=1
			session[:incorrect_guesses] << guess
		end
	end

	def lose?
		session[:guesses_left] <= 0 && session[:word_as_dashes].include?("_")
	end

	def win?
		session[:guesses_left] > 0 && !session[:word_as_dashes].include?("_")
	end

	class Game
		attr_reader :game_word
		def initialize
			@game_word = SecretWord.new.word
		end
	end

	class SecretWord
		attr_reader :word
		def initialize
			@word = select_word(open_file)
		end

		def word_as_dashes
			"_" * @word.length
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
				word.downcase
			end
		end	
	end
end