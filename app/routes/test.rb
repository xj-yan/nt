# endpoint related to test interface

class App < Sinatra::Base
	get '/test/reset' do
		# this is a test route
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