require 'sinatra/base'

module Test
	
	# get timeline of fan who follows star
	def get_test_timeline(star, fan)
		timeline = []
		if Follow.find_by(followee_id: star, follower_id: fan).nil?
			timeline
		else
			timeline = Tweet.where(user_id: star).order(created_at: :desc).first(50)  
		end
	end

	# get test tweet with given tweet ids
	def get_test_tweet(tweet_ids)
		data = Tweet.where(id: tweet_ids)
	end	
end
