require_relative "lib/hangman.rb"

def recieve_guess_input(game)
    puts "You have guessed the following letters: #{game.letters_guessed}"
    puts "Please enter a new character to guess with or enter 'save' to save the current state and exit: "
    while true
        input = gets.chomp.downcase
        if(input == 'save')
            puts "Please enter the name of your save game: "
            fname = gets.chomp
            game.save_state(fname)
            return true
        end
        input = input.split("")
        if(input.length > 1)
            puts "Please only enter a single character."
        elsif(game.letters_guessed.include?(input[0]))
            puts "You have already guessed that character."
        elsif(!game.valid_chars.include?(input[0]))
            puts "Sorry that isn't a valid letter, please try again."
        else
            return input[0]
        end
    end
end

def game_loop(game)
    save_and_exit = false
    until game.won? || game.out_of_guesses?
        game.show_remaining_guesses
        game.show_board
        continue = recieve_guess_input(game)
        if(continue.is_a?(String))
            game.recieve_new_guess(continue)
        else
            save_and_exit = true
            break
        end
    end
    if game.won?
        puts "Congrats you managed to guess the word #{game.word}!"
    elsif save_and_exit
        puts "Game saved..."
    else
        puts "Better luck next time, the word was #{game.word}"
    end
end


while true
    game = Hangman.new

    puts "Welcome to Hangman the Game!"
    puts "Would you like to load a previously saved game or start a new game? (l = load, n = new, e = exit):"
    input = ""
    while true
        input = gets.chomp.downcase
        if(input != "l" && input != "n" && input != "e")
            puts "Please enter the letter l, n or e:"
        else
            break
        end
    end
    if input == "n"
        game_loop(game)
    elsif input == "l"
        game.show_saves
        return_to_menu = false
        puts "Please enter the name of the save you want to load or e to return to the main menu:"
        while true
            input = gets.chomp
            if(input == "e")
                return_to_menu = true
                break
            end
            begin
                game.load_state(input)
                break
            rescue
                puts "Sorry that isn't a save file, try again."
            end
        end
        unless return_to_menu
            game_loop(game)
        end
    else
        break
    end
end

