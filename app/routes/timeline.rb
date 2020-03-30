require 'json'
require 'sinatra/contrib'

class App < Sinatra::Base
	register Sinatra::Contrib
	get '/tweet' do
		act = params[:act]
		id = session[:user_id]
		if act == 'get_page_count'
			@count = get_page_count(id).to_json
		elsif act == 'get_tweet_list'
			page_num = params[:page]
			res = []
			tweets = get_tweet_list(id, page_num)
			tweets.each do |tweet|
				res << tweet["tweet"]
			end
			res.to_json
		end
	end 
end