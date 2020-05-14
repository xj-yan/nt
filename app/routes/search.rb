# endpoint related to search
require 'json'
require 'net/http'

class App < Sinatra::Base

	get '/search' do
		q = params[:query]
		puts "search starting.."
		result = $redis.get("search/#{q}")
		if result.nil?
			uri = URI("http://161.35.6.102/search")
			params = {:query => q}
			uri.query = URI.encode_www_form(params)
			response = Net::HTTP.get_response(uri)
			puts response.body if response.is_a?(Net::HTTPSuccess)
			res = JSON.parse(response.body)
			if !res.nil?
				@res = res
			else
				@res = []
			end
			$redis.set("search/#{q}", @response.body)
			# Expire the cache, every 15 minutes
			$redis.expire("search/#{q}", 15.minute.to_i)
		else
			@res = JSON.parse(result)
		end
		puts "search ending.."
		erb :search
	end

end