require "http"
require "tty-box"
require "tty-screen"
require "pstore"
require "tty-table"

def get_movie_ratings
  puts "Please enter a movie:"
  user_entry = gets.chomp
  omdb_api_endpoint = "http://www.omdbapi.com/?apikey=#{ENV["OMDB_API_KEY"]}&t=#{user_entry}&plot=full"
  response = HTTP.get(omdb_api_endpoint)

  if response.code == 200
    JSON.parse(response.body)
  else
    puts "Request failed with status code #{response.code}"
  end
end

def display_movie_ratings(movie_info)
  box = TTY::Box.frame(
    width: TTY::Screen.width / 2,
    height: TTY::Screen.height / 2,
    border: :thick,
    padding: [1, 3, 1, 3],
    title: {
      top_left: " #{movie_info["Title"]} ",
      bottom_right: " Rating: #{movie_info["imdbRating"]} ",
    },
    style: {
      fg: :magenta,
      bg: :cyan,
      border: {
        fg: :magenta,
        bg: :cyan,
      },
    },
  ) do
    "Release Year: #{movie_info["Year"]}\n\n" +
    "Genre: #{movie_info["Genre"]}\n\n" +
    "Directed by: #{movie_info["Director"]}\n\n" +
    "Cast: #{movie_info["Actors"]}\n\n" +
    "Plot: #{movie_info["Plot"]}"
  end
  puts box
end

def main
  movie_info = get_movie_ratings
  display_movie_ratings(movie_info)
end

puts "Welcome to the Movie Tracker!"
while true
  system "clear"
  puts "[M]ovieLookup  [R]eadList  [Q]uit"
  input_choice = gets.chomp.downcase
  if input_choice == "m"
    system "clear"
    main if __FILE__ == $PROGRAM_NAME
    print "Press enter to continue"
    gets.chomp
  elsif input_choice == "r"
    puts
  elsif input_choice == "q"
    puts "Thanks for using the Movie Tracker! Goodbye"
    break
  else
    puts "Invalid selection. Try again!"
    print "Press Enter to continue."
    gets.chomp
  end
end
