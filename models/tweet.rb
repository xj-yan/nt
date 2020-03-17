class Tweet < ActiveRecord::Base
	has_many :comments
	has_many :commenters, 
	:through => :comments, 
	:source => :user

	has_many :mentions
	has_many :mentioned_users,
	:through => :mentions, 
	:source => :user

	belongs_to :user

	has_many :has_tags
	has_many :tags, through: :has_tags


	
end
