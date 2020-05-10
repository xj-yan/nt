require 'bunny'
require 'sinatra/activerecord'

require_relative "./app/models/tweet"
# require_relative "./app/helpers/test"

conn = Bunny.new("amqp://admin:admin@167.99.1.171:5672")
conn.start
channel = conn.create_channel
q = channel.queue("bunny.test_3", :auto_delete => true)

q.subscribe(block: true) do |delivery_info, metadata, payload|
    puts "Received #{payload}"
    arr = payload.split(";")

    tag_str, mention_str = "", ""
    if content.include? '@'
        mention_str = arr[0].scan(/@\w+/).map{|str| str[1..-1]}.join(";")
        puts "mention created"
    end

    if content.include? '#'
        tag_str = arr[0].scan(/#\w+/).map{|str| str[1..-1]}.join(";")
    end

    tweet = Tweet.create(tweet: arr[0], user_id: arr[1].to_i, username: User.find(session[:user_id]).username, tag_str: tag_str, mention_str: mention_str)
    # update the home timeline of the followees
    # update_cached_home_timeline(id)

    # update the timeline of the user x
    # update_cached_user_timeline(id)
    tweet.to_json
end

# q.subscribe do |delivery_info, metadata, payload|
#     puts "Received #{payload}"
#     arr = payload.split(";")
#     tweet = make_tweet(arr[0], arr[1].to_i)
#     $ch.ack(delivery_info.delivery_tag)
#     tweet.to_json
# end

# class TweetQueue
#     def initialize
#         @conn = Bunny.new("amqp://admin:admin@167.99.1.171:5672")
#         @conn.start
#         @channel = @conn.create_channel
#         @queue = @channel.queue("tweetQueue")
#     end

#     def send tweetMsg
#         @channel.default_exchange.publish(tweetMsg, :routing_key => @queue.name)
#     end

#     def receive
#         @queue.subscribe do |delivery_info, metadata, payload|
#             puts "Received #{payload}"
#             arr = payload.split(";")
#             tweet = make_tweet(arr[0], arr[1].to_i)
#             tweet.to_json
#         end
#     end
# end