# endpoint related to test interface
require 'set'
require 'faker'


class App < Sinatra::Base

	get '/test' do
		# system("PGPASSWORD=iyajy1kgp2nczrpi pg_dump -h gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com -p 25060 -U doadmin --clean -Fc -t users nt_dev  > ./lib/backup/user_dump_file.pgsql")
		# system("PGPASSWORD=iyajy1kgp2nczrpi pg_dump -h gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com -p 25060 -U doadmin --clean -Fc -t follows nt_dev > ./lib/backup/follow_dump_file.pgsql")
		# system("PGPASSWORD=iyajy1kgp2nczrpi pg_dump -h gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com -p 25060 -U doadmin --clean -Fc -t tweets nt_dev > ./lib/backup/tweet_dump_file.pgsql")
		# puts "dumped"

		# system("PGPASSWORD=iyajy1kgp2nczrpi pg_dump -h gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com -p 25060 -U doadmin --clean -Fc nt_dev > ./lib/backup/db_dump_file.pgsql")

		user_size = User.all.size
		follow_size = Follow.all.size
		tweet_size = Tweet.all.size

		puts user_size
		puts follow_size
		puts tweet_size

		# User.delete_all
		Follow.delete_all
		# Tweet.delete_all

		system ("PGPASSWORD=iyajy1kgp2nczrpi pg_restore -d 'postgresql://doadmin:iyajy1kgp2nczrpi@gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com:25060/nt_dev?sslmode=require' --jobs 4 ./lib/backup/db_dump_file.pgsql")


		# system("PGPASSWORD=iyajy1kgp2nczrpi dropdb -h gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com -p 25060 -U doadmin nt_dev")

		# system("PGPASSWORD=iyajy1kgp2nczrpi drop table -h gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com -p 25060 -U doadmin users")

		# system("psql -U doadmin -h gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com -p 25060")
		
		# system("'postgresql://doadmin:iyajy1kgp2nczrpi@gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com:25060/nt_dev?sslmode=require' ")
		# system ("PGPASSWORD=iyajy1kgp2nczrpi pg_resotre -d 'postgresql://doadmin:iyajy1kgp2nczrpi@gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com:25060/nt_dev?sslmode=require' --jobs 4 ./lib/backup/user_dump_file.pgsql")
		# system ("PGPASSWORD=iyajy1kgp2nczrpi pg_restore -d 'postgresql://doadmin:iyajy1kgp2nczrpi@gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com:25060/nt_dev?sslmode=require' --jobs 4 follow_dump_file.pgsql")
		# system ("PGPASSWORD=iyajy1kgp2nczrpi pg_restore -d 'postgresql://doadmin:iyajy1kgp2nczrpi@gigatwitter-db-postgresql-do-user-7074878-0.db.ondigitalocean.com:25060/nt_dev?sslmode=require' --jobs 4 tweet_dump_file.pgsql")
		
		# puts "restored"

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

		count_1 = 0
		follow_list = []
		set = Set.new

		File.open("./lib/seeds/follows.csv") do |follows| 
			follows.read.each_line do |follow|
				follower_id, followee_id = follow.chomp.split(",")
				if follower_id.to_i > n && followee_id.to_i > n
					break
				end
				set << followee_id
				set << follower_id
				follow_list << {follower_id: follower_id, followee_id: followee_id}
				count_1 += 1
			end
			Follow.import follow_list
		end

		# Read users from users.csv into memory
		user_hash = Hash.new
		File.open("./lib/seeds/users.csv") do |users| 
			users.read.each_line do |user|
				id, username = user.chomp.split(",")
				if set.include?(id)
					user_hash[id] = username
				end
			end
		end

		count_2 = 0
		tweet_list = []
		File.open("./lib/seeds/tweets.csv") do |tweets| 
			tweets.read.each_line do |tweet|
				delimiters = [',"', '",']
				user_id, tweet_content, time = tweet.split(Regexp.union(delimiters))
				if user_id.to_i > n
					break
				end
				tweet_list << {tweet: tweet_content, user_id: user_id, username: user_hash[user_id], created_at: DateTime.parse(time), updated_at: DateTime.parse(time), tag_str: "",  mention_str: ""}
				count_2 += 1
				if count_2 == 60000
					Tweet.bulk_import tweet_list
					tweet_list = []
				end

			end
			Tweet.bulk_import tweet_list
		end

		count_3 = 0
		user_list = []
		
		user_hash.each do |user|
			id, username = user
			if !set.include?(id)
				next
			end
			follower_number = Follow.where(followee_id: id.to_i).length
			followee_number = Follow.where(follower_id: id.to_i).length
			tweet_number = Tweet.where(user_id: id.to_i).length

			user_list << {
				id: id.to_i + 1100,
				username: username, 
				email: Faker::Internet.email, 
				password_digest: BCrypt::Password.create("123"),
				follower_number: follower_number,
				followee_number: followee_number,
				tweet_number: tweet_number
			}
			count_3 += 1
		end
		User.import user_list
		
		return 200, "#{n} users have been reset. There are #{set.size} users in the database, with #{count_2} tweets and #{count_1} follows."
		
	end

	# # Test: get y random tweets of test user id x
	# '/test/tweet?user_id=x&tweet_count=y
	get '/test/tweet' do
		x = params[:user_id].to_i
		y = params[:tweet_count].to_i
		# user = User.find_by_id(x)
		user = get_user(x)
		if user.nil?
			return 400, "invalid user id!"
		end

		if y == 0
			return 400, "invalid tweet count!"
		end
		tweets = Array.new
		y.times do
			tweet = Tweet.create(tweet: Faker::Lorem.sentence(word_count: 6), user_id: x)
			tweets << tweet
		end

		# update the home timeline of the followees
		update_cached_home_timeline(x)

		# update the timeline of the user x
		# update_cached_user_timeline(x)

		puts "user #{x} posted #{y} tweets!"
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