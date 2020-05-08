require 'sinatra/base'

module Timeline

	def get_user(id)
		user = $redis.get("user/#{id}")
		if user.nil?
			user = User.find_by_id(id)
			$redis.set("user/#{id}", user.to_json)
			# Expire the cache, every 1 hours
			$redis.expire("user/#{id}", 1.hour.to_i)
		else
			user = JSON.parse(user)
		end
		user
  	end
			
	def get_timeline(id)
		if id == session[:user_id]
		# 	get_tweet(id)
		# else
		# 	get_tweet(get_followees(id))
		# end
			get_home_timeline(id)
		else
			get_user_timeline(id)
		end
	end

	# Get a list of ids
	def get_timeline_ids(id)
		followees = Follow.where(follower_id: id)
		ids = []
		ids << id
		followees.each do |f|
			ids << f["followee_id"]
		end
		ids.uniq
	end

	def get_home_timeline(id)

		following_ids = get_following_ids(id)

		timeline = []

		following_ids.each do |following_id|
			puts get_user_timeline(following_id)
			timeline += get_user_timeline(following_id)
		end

		timeline += get_user_timeline(id)

		timeline = timeline.sort_by { |t| t["created_at"].to_i }.reverse!
		@timeline = timeline.first(10)
	end

	def get_user_timeline(id)
		timeline = $redis.LRANGE("#{id}/user_timeline", 0, -1)
		@timeline = []
		if timeline.size == 0
			if Tweet.where(user_id: id).order(created_at: :desc).first(10).size == 0
				return @timeline
			end
		end
		timeline = $redis.LRANGE("#{id}/user_timeline", 0, -1)
		timeline.each do |t|
			t = JSON.parse(t)
			t["created_at"] = Time.parse(t["created_at"])
			@timeline << t
		end
		@timeline = @timeline.sort_by { |t| t["created_at"].to_i }.reverse!
	end

	def get_tweet_list(ids, page_num)
		tweets = get_timeline(ids)
		tweets[(page_num.to_i - 1) * 10, page_num.to_i * 10]
	end

	def get_page_count(ids)
		size = get_timeline(ids).size
		count = size / 10
		if size % 10 != 0
			count += 1
		end
		count
	end

	def get_name(id)
		name = User.find_by(id: id).username
	end
end
