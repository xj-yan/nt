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
		timeline = $redis.get("home_timeline/#{id}")
		if timeline.nil?
			followee_ids = get_following_ids(id)
			timeline = Tweet.where(user_id: followee_ids).order(created_at: :desc).first(10)
			$redis.set("home_timeline/#{id}", timeline.to_json)
			# Expire the cache, every 1 hours
			$redis.expire("home_timeline/#{id}", 1.hour.to_i)
		else
			timeline = JSON.parse(timeline)
		end
		timeline
	end

	def get_user_timeline(id)
		timeline = $redis.get("user_timeline/#{id}")
		if timeline.nil?
			timeline = Tweet.where(user_id: id).order(created_at: :desc).first(10)
			$redis.set("user_timeline/#{id}", timeline.to_json)
			# Expire the cache, every 1 hours
			$redis.expire("user_timeline/#{id}", 1.hour.to_i)
		else
			timeline = JSON.parse(timeline)
		end
		timeline
	end

	# Get a list of following ids
	def get_following_ids(id)
		ids = $redis.get("#{id}/following")
		if ids.nil?
			ids = []
			ids << id
			followees = Follow.where(follower_id: id)
			followees.each do |f|
				ids << f["followee_id"]
			end
			# $redis.set("#{id}/following", ids.uniq)
			# Expire the cache, every 1 hours
			# $redis.expire("#{id}/following",1.hour.to_i)
		else
			ids = JSON.parse(ids)
		end
		ids
	end

	# Get a list of follower ids
	def get_follower_ids(id)
		ids = $redis.get("#{id}/follower")
		if ids.nil?
			ids = []
			ids << id
			followers = Follow.where(followee_id: id)
			followers.each do |f|
				ids << f["follower_id"]
			end
		# if ids.nil?
		# 	followees = Follow.where(followee_id: id)
		# 	ids = []
		# 	ids << id
		# 	followees.each do |f|
		# 		ids << f["follower_id"]
		# 	end
			# $redis.set("follower_ids/#{id}", ids.uniq)
			# # Expire the cache, every 1 hours
			# $redis.expire("follower_ids/#{id}",1.hour.to_i)
		else
			ids = JSON.parse(ids)
		end
		ids
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
