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

	def get_tweet(ids)
		tweets = Tweet.where(user_id: ids).order(created_at: :desc)
	end

	def get_tweet_list(ids, page_num)
		tweets = get_tweet(ids)
		tweets[(page_num.to_i - 1) * 10, page_num.to_i * 10]
	end

	def get_page_count(ids)
		size = get_tweet(ids).size
		count = size / 10
		if size % 10 != 0
			count += 1
		end
		count
	end

	def valid_request?(request)
		request.xhr?
	end
end
