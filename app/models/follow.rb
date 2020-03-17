class Follow < ActiveRecord::Base
	belongs_to :fan, 
	:class_name => 'User', 
	:foreign_key => 'fan_id'
	belongs_to :idol, 
	:class_name => 'User', 
	:foreign_key => 'idol_id'
end
