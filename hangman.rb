require 'sinatra'
require 'sinatra/reloader'


game = Game.new
test = nil

get '/' do
	redirect to ('/newgame') if session[:completed_game] == true || session[:game_word].nil?

	erb :index
end

get '/newgame' do
	new_game

	redirect to ('/')
end


# post '/' do
# 	test = params["guess"]

# 	erb :index, :locals => {:word => word, :test => test}
# end

helpers do
	def new_game do
		session[:gameword] = SecretWord.new.word
		session[:completed_game] = false
	end

	class Game
		attr_reader :game_word
		def initialize
			@game_word = SecretWord.new.word
		end

		def word_as_dashes
			string = ''
			@game_word.length.times do |s|
				string = string + "_ "
			end
			string.chop!
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
end

# require 'yaml'

# module Hangman

# 	class StartGame
# 		def initialize
# 			display_main_menu_options
# 			run_user_selection
# 		end

# 		def display_main_menu_options
# 			text = 

# 		%q(
# 		Welcome to DV's Hangman!

# 		Please Select An Option.
# 		1. Start New Game
# 		2. Continue Saved Game
# 		3. Exit
# 		)

# 			puts text
# 		end

# 		def run_user_selection
# 			selection = gets.chomp.to_s
# 			case selection
# 			when "1"
# 				NewGame.new
# 			when "2"
# 				ExistingGame.new
# 			when "3"
# 				puts "Exiting Program.  Bye!"
# 				puts ""
# 				exit
# 			else
# 				puts "Invalid Input!"
# 				puts "Please enter either 1, 2, or 3"
# 				StartGame.new
# 			end
# 		end
# 	end

# 	class Board
# 		attr_accessor :board, :word, :covered_word
# 		def initialize (game_word)
# 			@word = game_word.word
# 			@covered_word = word_as_dashes
# 			@board = 
# 	%q(
#   |...1 
#   |  234
#   |   5
#   |   6
#   |  7 8
#   |________

# 	)		
# 		end

# 		def word_as_dashes
# 			string = ''
# 			@word.length.times do |s|
# 				string = string + "_ "
# 			end
# 			string.chop!
# 		end

# 		def update_covered_word(letter, indicies)
# 			indicies.each do |num|
# 				@covered_word[num*2] = letter
# 			end
# 		end

# 		def update_board(remaining)
# 			hangman_parts = " O/|\\||/\\"
# 			@board.gsub!(remaining.to_s, hangman_parts[remaining])
# 		end
# 	end

# 	class GameEngine
# 		attr_accessor :game_word, :board, :remaining, :guesses
# 		def initialize (game_word, board)
# 			@game_word = game_word.word
# 			@board = board
# 			@remaining = 8
# 			@guesses = []
# 		end

# 		def moves_left
# 			game_word.length
# 		end

#     def process_letter(letter)
#       if game_word.include?(letter.downcase)
#         matches = game_word.split("")
#         match_index = Array.new
#         matches.each_with_index do |check, index|
#           if check == letter
#             match_index << index
#           end
#         end
#         board.update_covered_word(letter, match_index)
#       else
#       	incorrect_guess(letter)
#       end
#     end

# 		def track_guesses(guess)
# 			guesses << guess
# 		end

# 		def incorrect_guess(letter)
# 			puts "Word Contains no #{letter.upcase}'s!"
#       track_guesses(letter)
#       board.update_board(@remaining)
#       @remaining -= 1
#     end

#     def all_letters
#       if board.covered_word.gsub(/\s+/, "") == game_word
#       	true
#       end
#     end

#     def has_winner?
#     	if all_letters
#     		puts "You Win!"
#     		puts "You Guessed: #{game_word}!"
#     		puts "GREAT JOB!"
#     		File.unlink("saved_game.txt") if File.exist?("saved_game.txt")
#     		true
#     	end
#     end

#     def has_loser?
#     	if @remaining == 0
#     		puts board.board
#     		# puts "Sorry, You Lose."
#     		# puts "The word was: #{@game_word}"
#     		true
#     	end
#     end
# 	end

# 	class SecretWord
# 		attr_accessor :word
# 		def initialize
# 			@word = select_word(open_file)
# 		end

# 		private

# 		def open_file
# 			f = File.open("words.txt", "r").readlines
# 			f.sample
# 		end

# 		def select_word(word)
# 			word.strip!
# 			if word.length < 5 || word.length > 12
# 				select_word(open_file)
# 			else
# 				word
# 			end
# 		end
# 	end

# 	class Game
# 		attr_reader :game_word, :board, :engine
# 		def initialize
# 			@game_word = SecretWord.new
# 			@board = Board.new(game_word)
# 			@engine = GameEngine.new(game_word, board)	
# 			active_game
# 		end

# 		def active_game
# 			loop do
# 				process_user_input #replace with params hash
# 				exit if engine.has_loser? #process in erb
# 				exit if engine.has_winner? #process in erb
# 			end
# 		end

# 		def process_user_input
# 			input = gets.chomp.to_s.downcase
# 			if input =~ /^[a-z]$/
# 				engine.process_letter(input)
# 			else
# 				"Invalid input"
# 			end
# 		end
# 	end
# end


# Hangman::StartGame.new