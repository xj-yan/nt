require 'json'

class App < Sinatra::Base
    post '/tweet' do
        authenticate!
        if session[:user_id] && User.find(session[:user_id])
            @user = User.find(session[:user_id])
            response = JSON.parse(request.body.read)
            # update the home timeline of the followees
            update_cached_home_timeline(@user.id)
            # update the timeline of the user x
            update_cached_user_timeline(@user.id)

            tweet = make_tweet(response["tweet"], @user.id)
            tweet.to_json
        else
            flash[:notice] = "The user doesn't exit."
        end
    end
end