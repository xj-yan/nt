# endpoint related to search
require 'json'

class App < Sinatra::Base

	get '/search' do
		uri = "http://161.35.6.102/search"
		response = Net::HTTP.post_form(
		uri, 'query' => params[:query])
		@res = response
		erb :search
	end

end