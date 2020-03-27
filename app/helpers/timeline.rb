require 'sinatra/base'

module Timeline
			
	def get_timeline(id)
		if id == session[:user_id]
			get_tweet(id)
		else
			get_tweet(get_followees(id))
		end
	end

	# Get a list of followee id
	def get_followees(id)
		followees = Follow.where(follower_id: id)
	end
	
	# Return first 10 tweet where id is in the given
	# id array in descending order
	# Action: increase number of tweet display using pagination
	def get_tweet(ids)
		tweets = Tweet.where(user_id: ids).order(created_at: :desc)
	end

end
