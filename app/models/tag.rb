class Tag < ActiveRecord::Base
	has_many :has_tags
	has_many :tweets, through: :has_tags
end
