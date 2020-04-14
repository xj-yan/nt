# endpoint related to test interface
require 'set'
require 'faker'

class App < Sinatra::Base

	# # This is a test route
	# get '/test' do
	# 	@users = User.all
	# 	erb :test
	# end

	get '/test/reset' do
		# total_user = params[:user_count].to_i
		User.delete_all
		Follow.delete_all
		Tweet.delete_all

		follow_list = []
		follow_column = [:follower_id, :followee_id]
		# set = Set.new
		File.open("./lib/seeds/follows.csv") do |follows| 
			follows.read.each_line do |follow|
				# follower_str, followee_str = follow.chomp.split(",")
				# follower_id = follower_str.to_i
				# followee_id = followee_str.to_i
				# if follower_id > total_user
				# 	break;
				# end
				# set << follower_str
				# set << followee_str
				follower_id, followee_id = follow.chomp.split(",")
				follow_list << {follower_id: follower_id, followee_id: followee_id}
			end
			Follow.import(follow_column, follow_list)
		end

		tweet_list = []
		tweet_column = [:tweet, :user_id, :created_at, :updated_at]
		File.open("./lib/seeds/tweets.csv") do |tweets| 
			tweets.read.each_line do |tweet|
				delimiters = [',"', '",']
				user_id, tweet, time = tweet.split(Regexp.union(delimiters))
				# if user_id.to_i > total_user
				# 	break;
				# end
				tweet_list << {tweet: tweet, user_id: user_id, created_at: DateTime.parse(time), updated_at: DateTime.parse(time)}
			end
			Tweet.import(tweet_column, tweet_list)
		end

		user_column = [:id, :username, :email, :password_digest]
		user_list = []
		File.open("./lib/seeds/users.csv") do |users| 
			users.read.each_line do |user|
				id, username = user.chomp.split(",")
				user_list << {id: id, username: username, 
							  email: Faker::Internet.email, 
							  password_digest: hash_password("123")}
				# if set.include? id
				# 	user_list << {id: id, 
				# 			  username: username, 
				# 			  email: Faker::Internet.email, 
				# 			  password_digest: hash_password("123")}
				# end
			end
			User.import(user_column, user_list)
		end
		status 200
	end

	# # Test: reset and add n random test users and t tweets
	# get '/test/reset?users=n&tweets=t' do
	# 	# load seed data
	# 	load './db/seeds.rb'
	# 	count = 0
	# 	n = params[:n]
	# 	t = params[:t]
	# 	users = []
	# 	tweets = []
	# 	follows = []
	# 	while count < n
	# 		# randomly select a user
	# 		user = User.all.sample()
	# 		# get all follows of the randomly selected user
	# 		follow = Follow.all.select{ |f|
	# 			f["fan_id"] == user["id"] or f["idol_id"] == user["id"]
	# 		}
	# 		# get all tweets of the randomly selected user
	# 		tweet = Tweet.all.select{ |t|
	# 			t["user_id"] == user["id"]
	# 		}
	# 		if !users.include?(user) and tweet.length >= t
	# 			users << user
	# 			tweets << tweet
	# 			follows << follow
	# 			count += 1
	# 	end
	# 	@users = users.to_json
	# 	@tweets = tweets.to_json
	# 	status 200
	# end

	# # Test: get y random tweets of test user id x
	# get '/test/tweet?user_id=x&tweet_count=y' do
	# 	x = params[:x]
	# 	y = params[:y]
	# 	user = User.find_by_id(x)
	# 	tweets = Tweet.all.select{ |t|
	# 			t["user_id"] == user["id"]
	# 		}
	# 	end
	# 	@user = user.to_json
	# 	@tweets = tweets.sample(y).to_json
	# 	status 200
	# end

	# Test: check validation
	# get '/test/validate?n=n' do
	# end

	get '/test/validate?n=n&star=u1&fan=u2' do
		n = params[:n].to_i
		star = params[:star].to_i
		fan = params[:fan].to_i
		
		# check follow status
		if Follow.find_by(followee_id: star, follower_id: fan).nil?
			Follow.create(followee_id: star, follower_id: fan)
			User.increment_counter(:followee_number, fan)
			User.increment_counter(:follower_number, star)
		end

		# post n tweets
		tweets = []
		tweet_ids = []
		n.times do |i|
			tweet = Tweet.create(tweet: Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false),
								 user_id: star
								)
			tweets << tweet
			tweet_ids << tweet.id
		end

		# validate id and tweet content
		# check size of returned tweets
		data = Tweet.where(id: tweet_ids)
		if data.size != tweet_ids.size
			return status 400
		end
		idx = 0
		# check tweet content
		while idx < tweets.size
			if tweets[idx].tweet != data[idx].tweet
				idx += 1
				return status 400
			end
		end
		# validate timeline
		# check user_id for first tweet in fan's timeline
		fan_timeline = get_tweet(fan)
		if fan_timeline.nil? || fan_timeline[0].user_id != star
			return status 400
		end
		return status 200
	end
end