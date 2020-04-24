require 'csv'
require 'faker'

# require_relative '../app/helpers/authentication'

# Create users from users.csv
count_1 = 0
# user_column = [:id, :username, :email, :password_digest, :follower_number, :followee_number]
# user_list = []
File.open("./lib/seeds/users.csv") do |users| 
	users.read.each_line do |user|
		id, username = user.chomp.split(",")

		# user_list << {id: id, 
		# 	username: username, 
		# 	email: Faker::Internet.email, 
		# 	password_digest: hash_password("123"),
		# 	follower_number: 0,
		# 	followee_number: 0
		# }
		# count_1 += 1
		User.create(
			username: username, 
			email: Faker::Internet.email, 
			password: "123",
			follower_number: 0,
			followee_number: 0)
		count_1 = count_1 + 1
	end
end

puts "#{count_1} users now created"
#1000

# Create tweets from tweets.csv
count_2 = 0
tweet_list = []
tweet_column = [:tweet, :user_id, :created_at, :updated_at]
File.open("./lib/seeds/tweets.csv") do |tweets| 
	tweets.read.each_line do |tweet|
		delimiters = [',"', '",']
		user_id, tweet, time = tweet.split(Regexp.union(delimiters))
		tweet_list << {tweet: tweet, user_id: user_id, created_at: DateTime.parse(time), updated_at: DateTime.parse(time)}
		count_2 = count_2 + 1
	end
	Tweet.import(tweet_column, tweet_list)
end

puts "#{count_2} tweets now created"
# 100175

# Create follows from follows.csv
count_3 = 0
follow_list = []
follow_column = [:follower_id, :followee_id]
File.open("./lib/seeds/follows.csv") do |follows| 
	follows.read.each_line do |follow|
		follower_id, followee_id = follow.chomp.split(",")
		follow_list << {follower_id: follower_id, followee_id: followee_id}
		User.increment_counter(:followee_number, follower_id)
		User.increment_counter(:follower_number, followee_id)
		count_3 = count_3 + 1
	end
	Follow.import(follow_column, follow_list)
end

puts "#{count_3} following relationships now created"
# 4923