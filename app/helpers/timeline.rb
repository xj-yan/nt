require 'sinatra/base'

module Timeline

	# get user info
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

	# get username
	def get_name(id)
		name = get_user(id)["username"]
	end
	
	# get home/user timeline
	def get_timeline(id)
		if id == session[:user_id]
			get_home_timeline(id)
		else
			get_user_timeline(id)
		end
	end

	# Get user id of tweet appear on timeline
	def get_timeline_ids(id)
		followees = Follow.where(follower_id: id)
		ids = []
		ids << id
		followees.each do |f|
			ids << f["followee_id"]
		end
		ids.uniq
	end

	# get a list of tweet
	def get_tweet_list(ids, page_num)
		tweets = get_timeline(ids)
		tweets[(page_num.to_i - 1) * 10, page_num.to_i * 10]
	end

	# get page count
	def get_page_count(ids)
		size = get_timeline(ids).size
		count = size / 10
		if size % 10 != 0
			count += 1
		end
		count
	end

	# get home timeline
	def get_home_timeline(id)
		timeline = $redis.get("#{id}/home_timeline")
		if timeline.nil?
			following_ids = get_following_ids(id)
			@timeline = Tweet.where(user_id: following_ids).order(created_at: :desc).first(10)
			$redis.set("#{id}/home_timeline", @timeline.to_json)
			$redis.expire("#{id}/home_timeline",15.minute.to_i)
		else
			@timeline = JSON.parse(timeline)
		end
		@timeline
	end

	# get user timeline
	def get_user_timeline(id)
		timeline = $redis.get("#{id}/user_timeline")
		if timeline.nil?
			@timeline = Tweet.where(user_id: id).order(created_at: :desc).first(10)
			$redis.set("#{id}/user_timeline", @timeline.to_json)
			$redis.expire("#{id}/user_timeline",15.minute.to_i)
		else
			@timeline = JSON.parse(timeline)
		end
		@timeline
	end

	# delete cached home timeline
	def update_cached_home_timeline(id)
		$redis.del("#{id}/home_timeline")
		follower_ids = get_follower_ids(id)
		follower_ids.each do |follower_id|
			timeline = $redis.get("#{follower_id}/home_timeline")
			if !timeline.nil?
				$redis.del("#{follower_id}/home_timeline")
			end
		end
	end

	# delete cached user timeline
	def update_cached_user_timeline(id)
		timeline = $redis.get("#{id}/user_timeline")
		if !timeline.nil?
			$redis.del("#{id}/user_timeline")
		end
	end

end
