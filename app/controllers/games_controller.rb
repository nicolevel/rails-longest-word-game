require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split(" ")
    @score = 0

    word_valid = validate_word(@word, @letters)
    word_length = @word.length

    if word_valid.zero?
      @message = 'This is not an English word.'
    elsif word_valid == 1
      @message = 'This is not found in grid'
    else
      @score = word_length
      @message = "Congrats your score is #{score}"
    end
  end

  def validate_word(attempt, grid)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    attempt_serialized = open(url).read
    api_data = JSON.parse(attempt_serialized)
    attempt_array = attempt.downcase.chars
    is_in_grid = attempt_array.all? { |letter| grid.count(letter) >= attempt_array.count(letter) }
    return 0 if api_data["found"] == false
    return 1 if is_in_grid == false
    return 2
  end
end
