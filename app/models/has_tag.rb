class HasTag < ActiveRecord::Base
	belongs_to :tweet
	belongs_to :tag
end
