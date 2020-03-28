require 'csv'
require 'faker'

# Create users from users.csv
File.open("./lib/seeds/users.csv") do |users| 
	users.read.each_line do |user|
		id, username = user.chomp.split(",")
		User.create(
			name: username, 
			email: Faker::Internet.email, 
			bio: Faker::Job.title, 
			password: Faker::Internet.password(min_length: 10, max_length: 20)
		)
end

puts "#{users.count} users now created"

# Create tweets from tweets.csv
File.open("./lib/seeds/tweets.csv") do |tweets| 
	tweets.read.each_line do |tweet|
		user_id, tweet, created_at = tweet.chomp.split(",")
		Tweet.create(
			tweet: tweet, 
			user_id: user_id,
			created_at: DateTime.parse(time),
			updated_at: DateTime.parse(time)
		)
end

puts "#{tweets.count} tweets now created"

# Create follows from follows.csv
File.open("./lib/seeds/follows.csv") do |follows| 
	follows.read.each_line do |follow|
		follower_id, followee_id = follow.chomp.split(",")
		Follow.create(
			follower_id: follower_id, 
			followee_id: followee_id
		)
end

puts "#{follows.count} tweets now created"
