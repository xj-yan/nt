require 'json'

class App < Sinatra::Base
    post '/tweet' do
        authenticate!
        if session[:user_id] && User.find(session[:user_id])
            @user = User.find(session[:user_id])
            response = JSON.parse(request.body.read)
            $x.publish("Hello!", :routing_key => $q.name)
            tweet = make_tweet(response["tweet"], @user.id)
            # tweet = Tweet.create(tweet: response["tweet"], user_id: @user.id)
            tweet.to_json
        else
            flash[:notice] = "The user doesn't exit."
        end
    end
end