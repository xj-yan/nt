require 'bunny'

$q.subscribe do |delivery_info, metadata, payload|
    puts "Received #{payload}"
    arr = payload.split(";")
    tweet = make_tweet(arr[0], arr[1].to_i)
    $ch.ack(delivery_info.delivery_tag)
    tweet.to_json
end