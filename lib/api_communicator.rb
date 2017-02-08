require 'rest-client'
require 'json'
require 'pry'

class Character
  attr_reader :name, :film_urls
  def initialize(character_hash)
    @name = character_hash["name"]
    @film_urls = character_hash["films"]
  end
end

character = Character.new("Han Solo")
character.name # => "Han Solo"

def get_all_characters
  puts "Be patient you must.. getting characters"

  url = 'http://www.swapi.co/api/people/'
  all_characters = []
  begin
    characters_raw =RestClient.get(url).body
    result = JSON.parse(characters_raw)
    all_characters += result["results"]
    url = result["next"]
  end while url

  all_characters.map do |character|
    Character.new(character)
  end

end

def find_character(characters, character_name)
  characters.find do |character|
    name = character.name
    name.downcase == character_name.downcase
  end
end

def find_films_for(character)
  film_urls = character.film_urls #need to know where character is
  film_urls.map do |film|
    result = RestClient.get(film)
    JSON.parse(result)
  end
end

def get_character_movies_from_api(character_name)
  #make the web request
  all_characters = get_all_characters
  found_character = find_character(all_characters, character_name)
  films = find_films_for(found_character)
  puts "#{found_character.name} has starred in:"

  films.each.with_index(1) do |film, index|
    puts "#{index}. #{film["title"]}"
  end

end


def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  film_titles = []
  films_hash.each do |film|
    film_titles << film["title"]
  end
  puts film_titles
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end

def get_movie_info_from_api(movie_name, category)
  film_rest_client = RestClient.get('www.swapi.co/api/films/')
  all_films = JSON.parse(film_rest_client)

  all_films["results"].each do |film|
    if film["title"] == movie_name
      return film[category]
    end
  end
end

def array_check?(category_array)
  category_array.class == Array
end

def show_movie_info(movie_name, category)
  movie_info = get_movie_info_from_api(movie_name, category)
  
  if array_check?(movie_info)
    category_array_of_hashes = get_hashes_from_urls(movie_info)
    parse_category_info(category_array_of_hashes)
  else
    puts movie_info
  end
end

def get_hashes_from_urls(array)
  new_array = []
  array.each do |category|
    category_client = RestClient.get(category)
    new_array << JSON.parse(category_client)
  end
  new_array
end

def parse_category_info(array)
  category_names = []

  array.each do |category|

    category_names << category["name"]
  end
  p category_names
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
