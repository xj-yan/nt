require 'json'
require 'sinatra/contrib'

class App < Sinatra::Base
	register Sinatra::Contrib
	get '/tweet' do
		act = params[:act]
		ids = get_timeline_ids(session[:user_id])
		if act == 'get_page_count'
			@count = get_page_count(ids).to_json
		elsif act == 'get_follow_tweet_list'
			page_num = params[:page]
			res = []
			tweets = get_tweet_list(ids, page_num)
			# tweets.each do |tweet|
			# 	res << tweet["tweet"]
			# end
			tweets.each do |tweet|
				user = User.find_by(id: tweet["user_id"]).username
				res << [user, tweet["tweet"], tweet["created_at"]]
			end
			res.to_json
		elsif act == 'get_user_tweet_list'
			ids = params[:username]
			page_num = params[:page]
			res = []
			tweets = get_tweet_list(ids, page_num)
			# tweets.each do |tweet|
			# 	res << tweet["tweet"]
			# end
			tweets.each do |tweet|
				user = User.find_by(id: tweet["user_id"]).username
				res << [user, tweet["tweet"], tweet["created_at"]]
			end
			res.to_json
		end
	end  
end