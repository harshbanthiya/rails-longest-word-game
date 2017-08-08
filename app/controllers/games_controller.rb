class GamesController < ApplicationController
	def game
		@grid = Array('A'..'Z').sample(20).join
		@start_time = Time.now
    end

	def game_validation(your_word,grid)
		attempt_up = your_word.upcase.split("")
		attempt_up.all? do |letter|
			attempt_up.count(letter) <= grid.count(letter)
		end
	end

	def english_validation(your_word)
		url = 'https://wagon-dictionary.herokuapp.com/'
		answer = url + your_word
		try = open(answer).read
		result = JSON.parse(try)
		result["found"]
	end

	def point_system(your_word, start_time, end_time)
		url = 'https://wagon-dictionary.herokuapp.com/'
		answer = url + your_word
		try = open(answer).read
		result = JSON.parse(try)
		length = your_word.length.to_i
		time = end_time - start_time.to_f
		length / time
	end

	def score
		@attempt = params[:query]
		@grid = params[:grid_query]
		@start_time = params[:start_time_query]
		@end_time = Time.now
		@time_difference = @end_time - @start_time.to_f 
		if game_validation(@attempt,@grid) == true
			if english_validation(your_word) == true
				hash = { time: @time_difference, score: point_system(@attempt,@start_time.to_f, @end_time), message: "well done"  }
			else
				hash = { time: @time_difference, score: 0, message: "not an english word"}
			end
		else
			hash = { time: @time_difference, score: 0, message: "not in the grid"}
		end
		@user_score = hash[:score]
	end
end
