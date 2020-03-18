# endpoint related to test timeline

class App < Sinatra::Base
	# Get y latest tweets of particular user x
	get '/users/tweet?user_id=x&tweet_count=y' do
		# find all tweets of a user with id x and sort by created_at in reverse chronological order
		tweets = Tweet.where(user_id: params[:x]).order(created_at: :desc)
		if tweets.empty?
			status 401
		else
			tweets.first(params[:y]).to_json
			status 200
		end
	end
end