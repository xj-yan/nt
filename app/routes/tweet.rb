require 'json'

class App < Sinatra::Base
    post '/tweet' do
        authenticate!
        if session[:user_id] && User.find(session[:user_id])
            @user = User.find(session[:user_id])
            response = JSON.parse(request.body.read)
            task_str = response["tweet"] + ";" + @user.id.to_s
            $x.publish(task_str, :routing_key => $q.name)

            puts task_str
            $x.publish(task_str, :routing_key => $q.name)
            $q.subscribe(manual_ack: true) do |delivery_info, metadata, payload|
                puts "Received #{payload}"
                arr = payload.split(";")
                tweet = make_tweet(arr[0], arr[1].to_i)
                tweet.to_json
                # return tweet.to_json
            end
            # puts response
            # tweet = make_tweet(response["tweet"], @user.id)
            # tweet.to_json
        else
            flash[:notice] = "The user doesn't exit."
        end
    end
end