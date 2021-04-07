require 'open-uri'
class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @letters = params[:letters]
    @word = params[:word].upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    if @included
      if @english_word
        @score = "Well done, #{@word} is a valid English word!"
      else
        @score = "Sorry, #{@word} is not a valid English word"
      end
    else
      @score = "Sorry, #{@word} can not be made using those letters."
    end
  end

  private

  def included?(word, letters)
    word.chars.all? do |letter|
      word.count(letter) <= letters.count(letter)
    end
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = open(url).read
    data = JSON.parse(response)
    data['found']
  end
end
