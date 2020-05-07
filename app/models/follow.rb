class Follow < ActiveRecord::Base
	belongs_to :follower, 
	:class_name => 'User', 
	:foreign_key => 'follower_id'
	belongs_to :followee, 
	:class_name => 'User', 
	:foreign_key => 'followee_id'

	# update cache after query for follow
	after_find do |user|
		puts "You have found #{user.followee_id} followed by #{user.follower_id}"
		# update cache for user_id/following
		if $redis.SMEMBERS("#{user.follower_id}/following").nil?
				$redis.SADD("#{user.follower_id}/following", user.follower_id)
		end
		$redis.SADD("#{user.follower_id}/following", user.followee_id)
		puts "#{user.followee_id} added to #{user.follower_id}/following"
		$redis.expire("#{user.follower_id}/following",5.minute.to_i)

		# update cache for user_id/follower
		$redis.SADD("#{user.followee_id}/follower", user.follower_id)
		puts "#{user.follower_id} added to #{user.followee_id}/follower"
		$redis.expire("#{user.followee_id}/follower",5.minute.to_i)
	end
end
