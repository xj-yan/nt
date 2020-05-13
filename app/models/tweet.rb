require 'elasticsearch/model'

class Tweet < ActiveRecord::Base
	# extend ActiveSupport::Concern

	has_many :comments
	has_many :commenters, 
	:through => :comments, 
	:source => :user

	has_many :mentions
	has_many :mentioned_users,
	:through => :mentions, 
	:source => :user

	belongs_to :user, class_name: "User"

	has_many :has_tags
	has_many :tags, through: :has_tags

	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

	settings do
		mappings dynamic: false do
			indexes :tweet, type: :text, analyzer: :english
			indexes :mention_str, type: :text
			indexes :tag_str, type: :text
		end
	end

	def as_indexed_json(options = {})
		self.as_json(
		only: [:tweet, :mention_str, :tag_str],
		include: {
			user: {
			only: [:username]
			}
		}
		)
	end
	 
	# update cache after tweet creation for timeline
	# after_create do |tweet|
	# 	timeline = $redis.get("#{tweet.user_id}/user_timeline")
	# 	if !timeline.nil?
	# 		$redis.del("#{tweet.user_id}/user_timeline")
	# 	end
 	# end
	
	# def self.search query
	# 	__elasticsearch__.search query
	# end

	# def self.import
	# 	__elasticsearch__.import
	# end
end

# create elasticsearch index
unless Tweet.__elasticsearch__.index_exists?
	Tweet.__elasticsearch__.create_index!
end
Tweet.__elasticsearch__.refresh_index!
# Tweet.import
# Tweet.__elasticsearch__.import
# Tweet.__elasticsearch__.delete_index!