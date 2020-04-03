# endpoint related to test interface
require 'set'

class App < Sinatra::Base

	# This is a test route
	get '/test' do
		@users = User.all
		erb :test
	end

	get '/test/reset' do
		total_user = params[:user_count].to_i
		User.delete_all
		Follow.delete_all
		Tweet.delete_all

		follow_list = []
		follow_column = [:follower_id, :followee_id]
		count = 0
		set = Set.new
		File.open("./lib/seeds/follows.csv") do |follows| 
			follows.read.each_line do |follow|
				follower_str, followee_str = follow.chomp.split(",")
				set << follower_str
				set << followee_str
				follower_id = follower_str.to_i
				followee_id = followee_str.to_i
				if follower_id > total_user
					break;
				end
				follow_column << {follower_id: follower_id, followee_id: followee_id}

			end
		end


		tweet_list = []
		tweet_column = [:tweet, :user_id, :created_at, :updated_at]
		File.open("./lib/seeds/tweets.csv") do |tweets| 
			tweets.read.each_line do |tweet|
				delimiters = [',"', '",']
				user_id, tweet, time = tweet.split(Regexp.union(delimiters))
				if user_id.to_i > total_user
					break;
				end
				tweet_list << {tweet: tweet, user_id: user_id, created_at: DateTime.parse(time), updated_at: DateTime.parse(time)}
			end
			Tweet.import(tweet_column, tweet_list)
		end

		user_column = [:id, :username, :email, :password_digest]
		user_list = []

		# user_list << {id: User.maximum(:id).next, username: Faker::Name.name, email: Faker::Internet.email, password_digest: hash_password("123")}
		# User.import(user_column, user_list)
		# puts "Done"

		File.open("./lib/seeds/users.csv") do |users| 
			users.read.each_line do |user|
				count += 1
				id, username = user.chomp.split(",")
				if set.include? id
					user_list << {id: id, 
							  username: username, 
							  email: Faker::Internet.email, 
							  password_digest: hash_password("123")}
				end

				# User.create(
				# 	id: id,
				# 	username: username, 
				# 	email: Faker::Internet.email, 
				# 	bio: Faker::Job.title, 
				# 	password: "123"
				# )
			end
			User.import(user_column, user_list)
		end

		# File.open("./lib/seeds/follows.csv") do |follows| 
		# 	follows.read.each_line do |follow|
		# 		follower_id, followee_id = follow.chomp.split(",")
		# 		Follow.create(
		# 			follower_id: follower_id, 
		# 			followee_id: followee_id
		# 		)
		# 	end
		# end
		status 200
	end

	# Test: reset and add n random test users and t tweets
	get '/test/reset?users=n&tweets=t' do
		# load seed data
		load './db/seeds.rb'
		count = 0
		n = params[:n]
		t = params[:t]
		users = []
		tweets = []
		follows = []
		while count < n
			# randomly select a user
			user = User.all.sample()
			# get all follows of the randomly selected user
			follow = Follow.all.select{ |f|
				f["fan_id"] == user["id"] or f["idol_id"] == user["id"]
			}
			# get all tweets of the randomly selected user
			tweet = Tweet.all.select{ |t|
				t["user_id"] == user["id"]
			}
			if !users.include?(user) and tweet.length >= t
				users << user
				tweets << tweet
				follows << follow
				count += 1
		end
		@users = users.to_json
		@tweets = tweets.to_json
		status 200
	end

	# Test: get y random tweets of test user id x
	get '/test/tweet?user_id=x&tweet_count=y' do
		x = params[:x]
		y = params[:y]
		user = User.find_by_id(x)
		tweets = Tweet.all.select{ |t|
				t["user_id"] == user["id"]
			}
		end
		@user = user.to_json
		@tweets = tweets.sample(y).to_json
		status 200
	end

	# Test: check validation
	# get '/test/validate?n=n' do
	# end
end