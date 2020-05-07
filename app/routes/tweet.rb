require 'json'

class App < Sinatra::Base
    post '/tweet' do
        authenticate!
        if session[:user_id] && User.find(session[:user_id])
            @user = User.find(session[:user_id])
            response = JSON.parse(request.body.read)
            task_str = "#{response["tweet"];#{@user.id}"
            puts task_str
            # $x.publish("Hello!", :routing_key => $q.name)
            # $q.subscribe do |delivery_info, metadata, payload|
            #     puts "Received #{payload} "
            #     tweet = make_tweet()
            # end
            # tweet = make_tweet(response["tweet"], @user.id)
            # tweet = Tweet.create(tweet: response["tweet"], user_id: @user.id)
            tweet.to_json
        else
            flash[:notice] = "The user doesn't exit."
        end
    end
end