require_relative "lib/hangman.rb"

game = Hangman.new

until game.won? || game.out_of_guesses?
    game.show_remaining_guesses
    game.show_board
    game.recieve_new_guess
end