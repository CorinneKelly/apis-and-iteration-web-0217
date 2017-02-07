require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)
  #make the web request
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)
  
  # iterate over the character hash to find the collection of `films` for the given
  #   `character`
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.
  
  films = []
  character_hash["results"].each do |char|
    if char["name"] == character
      films = char["films"]
    end
  end

  get_hashes_from_urls(films)
  film_array = []
  films.each do |film|
    film_client = RestClient.get(film)
    film_array << JSON.parse(film_client)
  end

  film_array

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
