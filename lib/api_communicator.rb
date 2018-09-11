require 'rest-client'
require 'json'
require 'pry'

# A user will run the program, see a lovely welcome message of your choosing, and then be prompted to enter the name of a character.

# Your program will capture that input and use it to query the Star Wars API for that characters films, `puts`-ing out to the terminal, the info about the films that character has appeared in.

def find_character(character_results, character_name)
  character_info = character_results.select do |character_hash|
    character_hash['name'].downcase == character_name
  end.first
end

def collect_film_info_from_character(character_info)
  films = []

  character_info['films'].each do |film_url|
    films << JSON.parse(RestClient.get(film_url))
  end

  films
end

def get_character_movies_from_api(character)
  #make the web request
  response_string = RestClient.get('http://www.swapi.co/api/people/')
  response_hash = JSON.parse(response_string)
  results_array = response_hash['results']



  character_info = find_character(results_array, character)

  collect_film_info_from_character(character_info)

  # NOTE: in this demonstration we name many of the variables _hash or _array.
  # This is done for educational purposes. This is not typically done in code.


  # iterate over the response hash to find the collection of `films` for the given
  #   `character`
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.
end

def print_movies(films_array, input_character_name)
  # some iteration magic and puts out the movies in a nice list
  # binding.pry
  pid = fork{ exec 'afplay', './lib/starwars.mp3' }
  films_array.each do |film|
    puts ''
    puts '-+-'
    puts film['title'].upcase
    puts "Director: #{film['director']}"
    puts "Starring #{input_character_name.split(' ').map { |n| n.capitalize}.join(' ') }"
    puts "Also starring: "
    film['characters'].each do |char_url|
      other_char_info = JSON.parse(RestClient.get(char_url))
      unless other_char_info['name'].downcase == input_character_name
        puts "  #{other_char_info['name']}"
      end
    end
  end
  puts ''
  `killall afplay`
end

def show_character_movies(character)
  films_array = get_character_movies_from_api(character)
  print_movies(films_array, character)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?


# title
# director
# starring user_character
# also starring...
#   character 2, 3, 4...
