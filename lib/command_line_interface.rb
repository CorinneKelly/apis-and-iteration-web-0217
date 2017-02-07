require_relative "api_communicator.rb"


def welcome
  # puts out a welcome message here!
  puts "Welcome to the Star Wars database!"

end

def check_valid_answer(string)
	until string == "yes" || string == "no"
		puts "Please say 'yes' or 'no'"
		string = gets.strip
	end
	string
end

def either_or
	puts "Would you like to look up what movies your favorite Star Wars character was in?"
	character_answer = gets.strip
	character_answer = check_valid_answer(character_answer)

	if character_answer == "yes"
		character = get_character_from_user
		show_character_movies(character)
	end

	puts "Would you like to look up other information about a specific movie?"
	movie_answer = gets.strip
	movie_answer = check_valid_answer(movie_answer)

	if movie_answer == "yes"
		movie_name = get_movie_name_from_user
		category_name = get_category_name_from_user
		show_movie_info(movie_name, category_name)
	end



end

def get_character_from_user
  puts "please enter a character"
  character_name = gets.strip
  character_name
  # use gets to capture the user's input. This method should return that input, downcased.
end

def get_movie_name_from_user
	puts "Please enter a Movie Name"
	movie_name = gets.strip
end

def get_category_name_from_user
	puts "Please enter a Category"
	category_name = gets.strip
end
