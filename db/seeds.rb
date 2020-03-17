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
		user_id, tweet, time = tweet.chomp.split(",")
		Tweet.create(
			tweet: tweet, 
			user_id: user_id
			time: time
		)
end

puts "#{tweets.count} tweets now created"

# Create follows from follows.csv
File.open("./lib/seeds/follows.csv") do |follows| 
	follows.read.each_line do |follow|
		follower_id, followee_id = follow.chomp.split(",")
		Follow.create(
			fan_id: followee_id, 
			idol_id: follower_id
		)
end

puts "#{follows.count} tweets now created"

# require 'sinatra'
# require 'sinatra/activerecord'
# require_relative '../models/user'
# require_relative '../models/follow'
# require_relative '../models/tweet'
# require_relative '../models/mention'
# require_relative '../models/has_tag'
# require_relative '../models/tag'

# # clean up the tables
# User.destroy_all
# Follow.destroy_all
# Tweet.destroy_all
# HasTag.destroy_all
# Mention.destroy_all
# Tag.destroy_all

# # create two twitter users
# User.create(
# 	name: 'jane', 
# 	email: "jane@gmail.com", 
# 	password: "#")
# User.create(
# 	name: 'mike', 
# 	email: "mike@gmail.com", 
# 	password: "#")
# jane = User.where(name: "jane").first
# mike = User.where(name: "mike").first

# # jane is a fan of mike
# f = Follow.new
# f.fan = jane
# f.idol = mike
# f.save


# # mike is a fan of jane
# f = Follow.new
# f.fan = mike
# f.idol = jane
# f.save

# # verify that the followship exists
# puts jane.fans.first.name
# puts jane.idols.first.name
# puts mike.fans.first.name
# puts mike.idols.first.name

# # jane posts a tweet
# jane_tweet = Tweet.create(
# 	tweet: "Jane says: my first tweet", 
# 	user_id: jane.id)
# # jane mentions mike
# Mention.create(tweet_id: jane_tweet.id, user_id: mike.id)
# # jane tags her post
# # first create a tag
# jane_tag = Tag.create(tag: "sinatra")
# HasTag.create(tweet_id: jane_tweet.id, tag_id: jane_tag.id)


# # mike posts a tweet
# mike_tweet = Tweet.create(
# 	tweet: "Mike says: my first tweet",
# 	user_id: mike.id)
# # mike mentions jane
# Mention.create(tweet_id: mike_tweet.id, user_id: jane.id)
# # mike tags his post
# # first create a tag
# mike_tag = Tag.create(tag: "gigatwitter")
# HasTag.create(tweet_id: mike_tweet.id, tag_id: mike_tag.id)

# # test jane's tweet
# puts jane_tweet.tweet
# # test jane tweet's mentions
# puts jane_tweet.mentioned_users.first.name
# # test jane tweet's tags
# puts jane_tweet.tags.first.tag

# # test jane's tweet
# puts mike_tweet.tweet
# # test jane tweet's mentions
# puts mike_tweet.mentioned_users.first.name
# # test jane tweet's tags
# puts mike_tweet.tags.first.tag