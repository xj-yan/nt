# endpoint related to test timeline

class App < Sinatra::Base
	
	helpers do
		# Get a list of followee id
		def get_followees(id)
			followees = Follow.where(fan_id: id)
		end
		
		# Return first 10 tweet where id is in the given
		# id array in descending order
		# Action: increase number of tweet display using pagination
		def get_tweet(ids)
			tweets = Tweet.where(user_id: ids).order(created_at: :desc).first(10)
		end
	end

	# Display home timeline in reverse chronological order 
	# if id is equal to id in session
	# Otherwise display timeline of following users'
	# Action: protected needed
	get '/users/:id/timeline' do
		id = params[:x]
		if id == session[:user_id]
			get_tweet(id)
		else
			get_tweet(get_followees(id))
		end
	end

end