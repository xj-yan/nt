# endpoint related to search
require 'json'

class App < Sinatra::Base

	get '/search' do
		@res = []
		uri = URI.join("http://#{settings.service}:#{settings.service_port}",
				 "/search")
		response = Net::HTTP.get_response(
		uri, 'query' => params[:query])
		h = response.code == "200" || response.code == "401" ? 
      JSON.parse(response.body) : {}
		if h["status"] == "success"
			@res = h["res"]
		end
		@res
		erb :search
	end

end