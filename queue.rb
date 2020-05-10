require 'bunny'
require_relative "./app/models/tweet"

conn = Bunny.new("amqp://admin:admin@167.99.1.171:5672")
conn.start
channel = conn.create_channel
q = channel.queue("bunny.test_3", :auto_delete => true)

q.subscribe(block: true) do |delivery_info, metadata, payload|
    puts "Received #{payload}"
    arr = payload.split(";")
    tweet = make_tweet(arr[0], arr[1].to_i)
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