# endpoint related to test interface
require 'set'
require 'faker'


class App < Sinatra::Base

	# # This is a test route
	# get '/test' do
	# 	@users = User.all
	# 	erb :test
	# end

	get '/test' do
		# system("PGPASSWORD=iyajy1kgp2nczrpi pg_dump -h gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com -p 25060 -U doadmin --clean -Fc -t users nt_dev  > ./lib/backup/user_dump_file.pgsql")
		# system("PGPASSWORD=iyajy1kgp2nczrpi pg_dump -h gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com -p 25060 -U doadmin --clean -Fc -t follows nt_dev > ./lib/backup/follow_dump_file.pgsql")
		# system("PGPASSWORD=iyajy1kgp2nczrpi pg_dump -h gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com -p 25060 -U doadmin --clean -Fc -t tweets nt_dev > ./lib/backup/tweet_dump_file.pgsql")
		# puts "dumped"
		user_size = User.all.size
		follow_size = Follow.all.size
		tweet_size = Tweet.all.size

		# User.delete_all
		# Follow.delete_all
		# Tweet.delete_all

		# system("PGPASSWORD=iyajy1kgp2nczrpi dropdb -h gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com -p 25060 -U doadmin nt_dev")

		# system("PGPASSWORD=iyajy1kgp2nczrpi drop table -h gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com -p 25060 -U doadmin users")

		# system("psql -U doadmin -h gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com -p 25060")
		
		# system("'postgresql://doadmin:iyajy1kgp2nczrpi@gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com:25060/nt_dev?sslmode=require' ")
		system ("PGPASSWORD=iyajy1kgp2nczrpi pg_resotre -d 'postgresql://doadmin:iyajy1kgp2nczrpi@gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com:25060/nt_dev?sslmode=require' --jobs 4 ./lib/backup/user_dump_file.pgsql")
		# system ("PGPASSWORD=iyajy1kgp2nczrpi pg_restore -d 'postgresql://doadmin:iyajy1kgp2nczrpi@gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com:25060/nt_dev?sslmode=require' --jobs 4 follow_dump_file.pgsql")
		# system ("PGPASSWORD=iyajy1kgp2nczrpi pg_restore -d 'postgresql://doadmin:iyajy1kgp2nczrpi@gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com:25060/nt_dev?sslmode=require' --jobs 4 tweet_dump_file.pgsql")
		
		puts "restored"

		if user_size == User.all.size && follow_size == Follow.all.size && tweet_size == Tweet.all.size
			return 200
		else
			return 400
		end
	end


	get '/test/reset' do

		# User.delete_all
		# Follow.delete_all
		# Tweet.delete_all
		n = params[:count].to_i

		if n == 1000
		else
			follow_list = []
			follow_column = [:follower_id, :followee_id]
			set = Set.new
			File.open("./lib/seeds/follows.csv") do |follows| 
				follows.read.each_line do |follow|
					follower_str, followee_str = follow.chomp.split(",")
					follower_id = follower_str.to_i + 1200
					followee_id = followee_str.to_i + 1200
					if follower_id - 1200 > n && followee_id - 1200 > n
						break;
					end
					set << follower_id
					set << followee_id
					follow_list << {follower_id: follower_id, followee_id: followee_id}
				end
				Follow.import(follow_column, follow_list)
			end

			user_column = [:id, :username, :email, :password_digest]
			user_list = []
			File.open("./lib/seeds/users.csv") do |users| 
				users.read.each_line do |user|
					id, username = user.chomp.split(",")
					# user_list << {id: id + 1000, username: username, 
					# 			  email: Faker::Internet.email, 
					# 			  password_digest: hash_password("123")}
					id = id.to_i + 1200
					if set.include? id
						user_list << {id: id, 
								username: username, 
								email: Faker::Internet.email, 
								password_digest: hash_password("123")}
					end
				end
				User.import(user_column, user_list)
			end

			tweet_list = []
			tweet_column = [:tweet, :user_id, :created_at, :updated_at]
			File.open("./lib/seeds/tweets.csv") do |tweets| 
				tweets.read.each_line do |tweet|
					delimiters = [',"', '",']
					user_id, tweet, time = tweet.split(Regexp.union(delimiters))
					if user_id.to_i > n + 1200
						break;
					end
					tweet_list << {tweet: tweet, user_id: user_id, created_at: DateTime.parse(time), updated_at: DateTime.parse(time)}
				end
				Tweet.import(tweet_column, tweet_list)
			end
			return 200, "#{n} users have been reset."
		end
	end


	# get '/test/reset' do
	# 	puts "test"


	# 	follow_list = []
	# 	follow_column = [:follower_id, :followee_id]
	# 	# set = Set.new
	# 	File.open("./lib/seeds/follows.csv") do |follows| 
	# 		follows.read.each_line do |follow|
	# 			# follower_str, followee_str = follow.chomp.split(",")
	# 			# follower_id = follower_str.to_i
	# 			# followee_id = followee_str.to_i
	# 			# if follower_id > total_user
	# 			# 	break;
	# 			# end
	# 			# set << follower_str
	# 			# set << followee_str
	# 			follower_id, followee_id = follow.chomp.split(",")
	# 			follow_list << {follower_id: follower_id, followee_id: followee_id}
	# 		end
	# 		Follow.import(follow_column, follow_list)
	# 	end

	# 	tweet_list = []
	# 	tweet_column = [:tweet, :user_id, :created_at, :updated_at]
	# 	File.open("./lib/seeds/tweets.csv") do |tweets| 
	# 		tweets.read.each_line do |tweet|
	# 			delimiters = [',"', '",']
	# 			user_id, tweet, time = tweet.split(Regexp.union(delimiters))
	# 			# if user_id.to_i > total_user
	# 			# 	break;
	# 			# end
	# 			tweet_list << {tweet: tweet, user_id: user_id, created_at: DateTime.parse(time), updated_at: DateTime.parse(time)}
	# 		end
	# 		Tweet.import(tweet_column, tweet_list)
	# 	end

	# 	user_column = [:id, :username, :email, :password_digest]
	# 	user_list = []
	# 	File.open("./lib/seeds/users.csv") do |users| 
	# 		users.read.each_line do |user|
	# 			id, username = user.chomp.split(",")
	# 			user_list << {id: id, username: username, 
	# 						  email: Faker::Internet.email, 
	# 						  password_digest: hash_password("123")}
	# 			# if set.include? id
	# 			# 	user_list << {id: id, 
	# 			# 			  username: username, 
	# 			# 			  email: Faker::Internet.email, 
	# 			# 			  password_digest: hash_password("123")}
	# 			# end
	# 		end
	# 		User.import(user_column, user_list)
	# 	end
	# 	status 200
	# end

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
	# '/test/tweet?user_id=x&tweet_count=y
	get '/test/tweet' do
		x = params[:user_id].to_i
		y = params[:tweet_count].to_i
		user = User.find_by_id(x)
		if user.nil?
			return 400, "invalid user id!"
		end

		# tweets = Tweet.where(user_id: x).sample(y)
		tweets = Array.new
		y.times do
			tweet = Tweet.create(tweet: Faker::Lorem.sentence(word_count: 6), user_id: x)
			tweets << tweet
		end
		return 200, tweets.to_json
	end

	get '/test/status' do
		report = Hash.new
		report["user"] = "There is #{User.all.size} users."
		report["follow"] = "There is #{Follow.all.size} follows."
		report["tweet"] = "There is #{Tweet.all.size} tweets."
		user = User.find_by(username: "testuser")
		if user.nil?
			return 400
		end
		report["testUser"] = "The id of test user is #{user.id}."
		return 200, report.to_json
	end

	# check validation
	get '/test/validate' do
		n = params[:n].to_i
		star = params[:star].to_i
		fan = params[:fan].to_i
		
		# check follow status
		if !check_follow(star, fan)
			follow_user(star, fan)
		end

		# post n tweets
		tweets = []
		tweet_ids = []
		n.times do |i|
			tweet = make_tweet(Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false), star)
			tweets << tweet
			tweet_ids << tweet.id
		end

		# validate id and tweet content
		# check size of returned tweets
		data = get_test_tweet(tweet_ids)
		if data.size != tweet_ids.size
			return 400, "tweet id validation failed!"
		end
		idx = 0
		# check tweet content
		while idx < tweets.size
			if tweets[idx].tweet != data[idx].tweet
				return 400, "tweet content validation failed!"
			end
			idx += 1
		end

		puts "tweets of star: #{star} are validated!"

		# validate timeline
		fan_timeline = get_test_timeline(star, fan)
		if fan_timeline.nil? || !tweet_ids.include?(fan_timeline[0].id)
			return 400, "timeline validation failed!"
		end
		puts "timeline of fan: #{star} is validated!"

		return 200, "validation for tweet no #{n} star #{star}, fan #{fan} is validated!"
		
	end

end