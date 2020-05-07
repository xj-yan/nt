require 'sinatra/base'
# helper functions related to follow relation

module Relation
  # Get a list of following ids
	def get_following_ids(id)
		ids = $redis.SMEMBERS("#{id}/following")
		if ids.size == 0
			ids = []
			# ids << id
			followees = Follow.where(follower_id: id)
			followees.each do |f|
				ids << f["followee_id"]
			end
		end
		ids
	end

	# Get a list of follower ids
	def get_follower_ids(id)
		ids = $redis.get("#{id}/follower")
		if ids.nil?
			followers = Follow.where(followee_id: id)
			followers.each do |f|
				ids << f["follower_id"]
			end
		# if ids.nil?
		# 	followees = Follow.where(followee_id: id)
		# 	ids = []
		# 	ids << id
		# 	followees.each do |f|
		# 		ids << f["follower_id"]
		# 	end
			# $redis.set("follower_ids/#{id}", ids.uniq)
			# # Expire the cache, every 1 hours
			# $redis.expire("follower_ids/#{id}",1.hour.to_i)
		end
		ids
	end

end