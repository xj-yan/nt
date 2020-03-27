require 'json'

class App < Sinatra::Base
    post '/tweet' do
        if session[:user_id] && User.find(session[:user_id])
            @user = User.find(session[:user_id])
            response = JSON.parse(request.body.read)
            tweet = Tweet.create(tweet: response["tweet"], user_id: @user.id)
            # @user.tweets << (Tweet.create(tweet: response["tweet"]))
        else
            flash[:notice] = "The user doesn't exit."
        end
    end
end