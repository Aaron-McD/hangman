require_relative "Serializable.rb"

class Hangman
    include Serializable
    attr_reader :word, :letters_guessed
    @@valid_chars = 'a'..'z'
    def initialize(word = nil, letters_guessed = [], incorrect_guesses_made = 0)
        if word != nil
            @word = word
        else
            @word = pick_word
        end
        @letters_guessed = letters_guessed
        @incorrect_guesses_made = incorrect_guesses_made
    end

    def won?
        guessed = false
        @word.downcase.split("").each do |char|
            if(@letters_guessed.include?(char))
                guessed = true
            else   
                guessed = false
                break
            end
        end
        return guessed
    end

    def recieve_new_guess(letter)
        @letters_guessed.push(letter)
        if(@word.downcase.include?(letter))
            puts "That character is in the word!"
        else
            @incorrect_guesses_made += 1
            puts "Sorry that's an incorrect guess!"
        end
    end

    def valid_chars
        return @@valid_chars
    end

    def show_saves
        if Dir.exist? "saves"
            children = Dir.children("saves")
            puts "These are your current save states:"
            children.each_with_index do |child, i|
                puts "#{i + 1}: #{child.gsub(".txt", "")}"
            end
        else
            puts "You have no current save files."
        end
    end

    def save_state(filename)
        Dir.mkdir "saves" unless Dir.exist? "saves"
        serial_string = self.serialize
        save = File.new("saves/#{filename}", "w")
        save.puts serial_string
    end

    def load_state(filename)
        load_contents = File.read "saves/#{filename}"
        File.delete("saves/#{filename}")
        self.unserialize(load_contents)
    end

    def out_of_guesses? 
        return @incorrect_guesses_made >= 6
    end

    def show_remaining_guesses
        puts "You have made #{@incorrect_guesses_made} incorrect guesses. You can only guess wrong #{6 - @incorrect_guesses_made} more times before your stick figure gets hung!"
    end

    def show_board
        out_string = "\n"
        @word.split("").each do |char|
            if(@letters_guessed.include?(char.downcase))
                out_string += "#{char} "
            else
                out_string += "_ "
            end
        end
        puts out_string
        puts "\n"
    end

    private

    def pick_word
        words = File.read "words.txt"
        words_array = words.split("\n")
        size = rand(5..12)
        possible_words = words_array.select { |word| word.length == size }
        return possible_words[rand(possible_words.length)]
    end
end