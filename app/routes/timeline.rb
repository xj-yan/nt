require 'json'
require 'sinatra/contrib'

class App < Sinatra::Base
	register Sinatra::Contrib
	get '/tweet' do
		act = params[:act]
		ids = get_followees(session[:user_id])
		if act == 'get_page_count'
			@count = get_page_count(ids).to_json
		elsif act == 'get_tweet_list'
			page_num = params[:page]
			res = []
			tweets = get_tweet_list(ids, page_num)
			tweets.each do |tweet|
				res << tweet["tweet"]
			end
			res.to_json
		end
	end  
end