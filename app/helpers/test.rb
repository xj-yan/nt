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
	
	# tweet
	def make_tweet(content, id)
		tweet = Tweet.create(tweet: content, user_id: id)
		puts "tweet created"
		if content.include? '@'
			mention_array = content.scan(/@\w+/).map{|str| str[1..-1]}
			mention_array.each do |mention|
				if User.find_by(username: mention).exist?
					user = User.find_by(username: mention)
					Mention.create(tweet_id: tweet.id, user_id: user.id)
					puts "mention created"
				end
			end
		end

		if content.include? '#'
			puts "include tag"
			tag_array = content.scan(/#\w+/).map{|str| str[1..-1]}
			puts tag_array
			tag_array.each do |tag|
				if Tag.find_by(tag: tag).nil?
					tag = Tag.find_by(tag: tag)
					Has_tag.create(tag_id: tag.id, tweet_id: tweet.id)
				else
					tag = Tag.create(tag: tag)
					Has_tag.create(tag_id: tag.id, tweet_id: tweet.id)
				end
				puts "tag created"

			end
		end
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
end
