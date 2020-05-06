require 'csv'
require 'faker'
require 'bcrypt'

# User.delete_all
Tweet.delete_all
# Follow.delete_all


# Create follows from follows.csv

# count_1 = 0
# follow_list = []
# # follow_column = [:follower_id, :followee_id]

# File.open("./lib/seeds/follows.csv") do |follows| 
# 	follows.read.each_line do |follow|
# 		follower_id, followee_id = follow.chomp.split(",")
# 		follow_list << {follower_id: follower_id, followee_id: followee_id}
# 		# User.increment_counter(:followee_number, follower_id)
# 		# User.increment_counter(:follower_number, followee_id)
# 		count_1 = count_1 + 1
# 	end
# 	Follow.import follow_list
# end

# puts "#{count_1} following relationships now created"

# # 4923


# # Create users from users.csv

# count_3 = 0
# # user_column = [:id, :username, :email, :password_digest, :follower_number, :followee_number, :tweet_number]
# user_list = []

# File.open("./lib/seeds/users.csv") do |users| 
# 	users.read.each_line do |user|
# 		id, username = user.chomp.split(",")
# 		follower_number = Follow.where(followee_id: id.to_i).length
# 		followee_number = Follow.where(follower_id: id.to_i).length
# 		# tweet_number = Tweet.where(user_id: id.to_i).length

# 		user_list << {
# 			id: id.to_i,
# 			username: username, 
# 			email: Faker::Internet.email, 
# 			password_digest: BCrypt::Password.create("123"),
# 			follower_number: follower_number,
# 			followee_number: followee_number,
# 			tweet_number: 0
# 		}
# 		count_3 += 1
# 	end
# 	User.import user_list
# end
# puts "#{count_3} users now created"

# #1000


# Create tweets from tweets.csv

count_2 = 0
tweet_list = []
# tweet_column = [:tweet, :user_id, :created_at, :updated_at, :tag_str, :mention_str]

File.open("./lib/seeds/tweets.csv") do |tweets| 
	tweets.read.each_line do |tweet|
		delimiters = [',"', '",']
		user_id, tweet_content, time = tweet.split(Regexp.union(delimiters))
		user = User.find(user_id.to_i)
		tweet_list << {tweet: tweet_content, user_id: user_id, username: user.username, created_at: DateTime.parse(time), updated_at: DateTime.parse(time), tag_str: "",  mention_str: ""}
		count_2 += 1
		if count_2 == 60000
			break
		end
	end
	Tweet.bulk_import tweet_list
end
puts "#{count_2} tweets now created"

User.all.each do |user|
	user.tweet_number = Tweet.where(user_id: user.id).length
	user.save!
end

puts "#{User.all.length} users are updated their tweet number."

# tweet_list = []
# tmp = 0
# File.open("./lib/seeds/tweets.csv") do |tweets| 
# 	tweets.read.each_line do |tweet|
# 		if tmp < 8000
# 			tmp += 1
# 			next
# 		end
# 		delimiters = [',"', '",']
# 		user_id, tweet_content, time = tweet.split(Regexp.union(delimiters))
# 		tweet_list << {tweet: tweet_content, user_id: user_id, created_at: DateTime.parse(time), updated_at: DateTime.parse(time), tag_str: "",  mention_str: ""}
# 		count_2 += 1
# 	end
# 	Tweet.bulk_import tweet_list
# end
# puts "#{count_2} tweets now created"

# 100175



