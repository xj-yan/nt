require 'sinatra/base'
require 'json'

module Test

	# # Get a list of ids
	# def get_followee_ids(id)
	# 	ids = $redis.get("followee_ids/#{id}")
	# 	if ids.nil?
	# 		followees = Follow.where(follower_id: id)
	# 		ids = []
	# 		ids << id
	# 		followees.each do |f|
	# 			ids << f["followee_id"]
	# 		end
	# 		$redis.set("followee_ids/#{id}", ids.uniq)
	# 		# Expire the cache, every 1 hours
	# 		$redis.expire("followee_ids/#{id}",1.hour.to_i)
	# 	else
	# 		ids = JSON.parse(ids)
	# 	end
	# 	ids
	# end

	# get timeline of fan who follows star
	def get_test_timeline(star, fan)

		timeline = $redis.get("home_timeline/#{fan}")
		if timeline.nil?
			timeline = Tweet.where(user_id: star).order(created_at: :desc).first(10)
			$redis.set("home_timeline/#{fan}", timeline.to_json)
			# Expire the cache, every 1 hours
			$redis.expire("home_timeline/#{fan}", 1.hour.to_i)
		else
			timeline = JSON.parse(timeline)
		end
		timeline
		# if Follow.find_by(followee_id: star, follower_id: fan).nil?
		# 		timeline = []
		# else
		# 	timeline = Tweet.where(user_id: star).order(created_at: :desc).first(10)  
		# end
		# timeline
	end

	# get test tweet with given tweet ids
	def get_test_tweet(tweet_ids)
		data = Tweet.where(id: tweet_ids)
	end
	
	# tweet
	def make_tweet(content, id)
		tag_str, mention_str = "", ""
		if content.include? '@'
			mention_str = content.scan(/@\w+/).map{|str| str[1..-1]}.join(";")
			puts "mention created"
		end

		if content.include? '#'
			tag_str = content.scan(/#\w+/).map{|str| str[1..-1]}.join(";")
		end

		tweet = Tweet.create(tweet: content, user_id: id, username: User.find(session[:user_id].username), tag_str: tag_str, mention_str: mention_str)

		# update the home timeline of the followees
		update_cached_home_timeline(id)

		# update the timeline of the user x
		update_cached_user_timeline(id)
    	return tweet
	end

	# check follow relation
	def check_follow(star, fan)
		return !Follow.find_by(followee_id: star, follower_id: fan).nil?
	end

	# create follow relation
	def follow_user(star, fan)
		Follow.create(followee_id: star, follower_id: fan)
		User.increment_counter(:followee_number, fan)
		User.increment_counter(:follower_number, star)
	end

	# Get a list of folloer ids
	def get_follower_ids(id)
		ids = $redis.get("follower_ids/#{id}")
		if ids.nil?
			followees = Follow.where(followee_id: id)
			ids = []
			ids << id
			followees.each do |f|
				ids << f["follower_id"]
			end
			$redis.set("follower_ids/#{id}", ids.uniq)
			# Expire the cache, every 1 hours
			$redis.expire("follower_ids/#{id}",1.hour.to_i)
		else
			ids = JSON.parse(ids)
		end
		ids
	end

	def update_cached_home_timeline(user_id)
		# get list of follower ids for the given user
		follower_ids = get_followee_ids(user_id)
		follower_ids.each do |follower_id|
			if !$redis.get("home_timeline/#{follower_id}").nil?
				ids = get_followee_ids(follower_id)
				# $redis.del("home_timeline/#{follower_id}")
				home_timeline = Tweet.where(user_id: ids).order(created_at: :desc).first(10)
				$redis.set("home_timeline/#{follower_id}", home_timeline.to_json)
				# Expire the cache, every 1 hours
				$redis.expire("home_timeline/#{follower_id}",1.hour.to_i)
			end
		end
	end

	def update_cached_user_timeline(user_id)
		if !$redis.get("user_timeline/#{user_id}").nil?
			user_timeline = Tweet.where(user_id: user_id).order(created_at: :desc).first(10)
			$redis.set("user_timeline/#{user_id}", user_timeline.to_json)
			# Expire the cache, every 1 hours
			$redis.expire("user_timeline/#{user_id}",1.hour.to_i)
		end
	end
end


