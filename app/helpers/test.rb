require 'sinatra/base'
require 'json'

module Test

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

		tweet = Tweet.create(tweet: content, user_id: id, username: User.find(session[:user_id]).username, tag_str: tag_str, mention_str: mention_str)
		# update the home timeline of the followees
		# update_cached_home_timeline(id)

		# update the timeline of the user x
		# update_cached_user_timeline(id)
    return tweet
	end

	# check follow relation
	def check_follow(star, fan)
		# return !Follow.find_by(followee_id: star, follower_id: fan).nil?
		ids = JSON.parse($redis.get("#{star}/follower"))
		return ids.include?(fan)
	end

	# create follow relation
	def follow_user(star, fan)
		Follow.create(followee_id: star, follower_id: fan)
		User.increment_counter(:followee_number, fan)
		User.increment_counter(:follower_number, star)
	end
end


