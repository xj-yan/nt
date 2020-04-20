require 'sinatra/base'

module Basic
    def make_tweet(content, id)
        tweet = Tweet.create(tweet: content, user_id: id)
        return tweet
    end

    def check_follow(star, fan)
        return !Follow.find_by(followee_id: star, follower_id: fan).nil?
    end

    def follow_user(star, fan)
        Follow.create(followee_id: star, follower_id: fan)
        User.increment_counter(:followee_number, fan)
        User.increment_counter(:follower_number, star)
    end
end