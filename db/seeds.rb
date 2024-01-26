# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# require_relative "../app/models/movie.rb"

# p "Cleaning DB ..."
# Movie.destroy_all

# p "Starting to seed ..."

# p Movie.create(title: "Wonder Woman 1984", overview: "Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s", poster_url: "https://image.tmdb.org/t/p/original/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg", rating: 6.9)
# p Movie.create(title: "The Shawshank Redemption", overview: "Framed in the 1940s for double murder, upstanding banker Andy Dufresne begins a new life at the Shawshank prison", poster_url: "https://image.tmdb.org/t/p/original/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg", rating: 8.7)
# p Movie.create(title: "Titanic", overview: "101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic.", poster_url: "https://image.tmdb.org/t/p/original/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg", rating: 7.9)
# p Movie.create(title: "Ocean's Eight", overview: "Debbie Ocean, a criminal mastermind, gathers a crew of female thieves to pull off the heist of the century.", poster_url: "https://image.tmdb.org/t/p/original/MvYpKlpFukTivnlBhizGbkAe3v.jpg", rating: 7.0)

# p "Seeding done."

# # WITH API
require 'net/http'
require "json"

p "Cleaning DB ..."
Bookmark.destroy_all
# List.destroy_all
Movie.destroy_all

p "Starting to seed ..."

years = (1980 .. 2023).to_a

favorite_movies_per_year = {}

years.each do |year|

  url = URI("https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&year=#{year}")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request["accept"] = 'application/json'
  request["Authorization"] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YTI1MTBmNWM0MzUyZjMyNjIyNjMyYmYzZDUxMTM2NSIsInN1YiI6IjY1YjM5NTkzNWUxNGU1MDE4MzBjNWE5NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Sa6McpBfVMiwYz1ozBDE6TNy81ef0maCG_p6QFQQhsw'

  response = http.request(request).read_body

  favorite_movies_per_year[year] = JSON.parse(response)
end

movie_params = {
  title: "",
  overview: "",
  poster_url: "",
  rating: 0.0,
}

favorite_movies_per_year.each_key do |year|
  p year
  favorite_movies_per_year.dig(year, "results").each do |movie|
    movie_params[:title] = movie["original_title"]
    movie_params[:overview] = movie["overview"]
    movie_params[:poster_url] = "https://image.tmdb.org/t/p/original#{movie['poster_path']}"
    movie_params[:rating] = movie["vote_average"]

    p Movie.create(movie_params)
  end
end

p "Seeding done."
