require 'sinatra/base'
# helper functions related to follow relation

module Relation
  # Get a list of following ids
	def get_following_ids(id)
		ids = $redis.get("#{id}/following")
		if ids.nil?
			following = Follow.where(followee_id: id)
			ids = []
			ids << id
			following.each do |f|
				ids << f["follower_id"]
			end
			$redis.set("#{id}/following", ids.uniq)
			# Expire the cache, every 15 minutes
			$redis.expire("#{id}/following", 15.minute.to_i)
		end
		ids
	end

	# Get a list of follower ids
	def get_follower_ids(id)
		ids = $redis.get("#{id}/follower")
		if ids.nil?
			followees = Follow.where(followee_id: id)
			ids = []
			ids << id
			followees.each do |f|
				ids << f["follower_id"]
			end
			$redis.set("#{id}/follower", ids.uniq)
			# Expire the cache, every 15 minutes
			$redis.expire("#{id}/follower", 15.minute.to_i)
		else
			ids = JSON.parse(ids)
		end
		ids
	end

end