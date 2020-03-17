# entry point
require 'sinatra'
require 'faker'

require_relative './models/user'

set :database_file, 'config/database.yml'


# create a user account
post '/user/register' do
  name = params[:name]
  email = params[:email]
  password = params[:password]
  # check if the email has been registered
  user = User.find_by(email: email)
  if user != nil
    puts "the user already exists"
    status 401
  else
    new_user = User.new(
      name: name, 
      email: email, 
      password: password)
    if new_user.save
      status 200
      {
       :user_id => new_user.id,
      }.to_json
    else
      status 401
    end
  end
end

# user authentication
post '/user/validate' do
  email = params[:email]
  password = params[:password]
  user = User.find_by(email: email)
  if user == nil
    status 401
    {
      :user_id => nil,
      :status => "user does not exist"
    }.to_json
  else
    if user.authenticate(password)
      status 200
      {
        :user_id => user.id,
        :status => "success"
      }.to_json
    else
      status 401
      {
        :user_id => nil,
        :status => "wrong password"
      }.to_json
    end
  end
end

# Get y latest tweets of particular user x
get '/users/tweet?user_id=x&tweet_count=y' do
  # find all tweets of a user with id x and sort by created_at in reverse chronological order
  tweets = Tweet.where(user_id: params[:x]).order(created_at: :desc)
  if tweets.empty?
    status 401
  else
    tweets.first(params[:y]).to_json
    status 200
  end
end

# # Create n test users.
# post 'test/users/create' do
#   count = params[:n].to_i || 1
#   if count > 30
#     status 400
#   end
#   status 200
# end

# Test: get test interface
get '/test/' do
  erb :index
end

# Test: reset and add n random test users and t tweets
get '/test/reset?users=n&tweets=t' do
  # load seed data
  load './db/seeds.rb'
  count = 0
  n = params[:n]
  t = params[:t]
  users = []
  tweets = []
  follows = []
  while count < n
    # randomly select a user
    user = User.all.sample()
    # get all follows of the randomly selected user
    follow = Follow.all.select{ |f|
      f["fan_id"] == user["id"] or f["idol_id"] == user["id"]
    }
    # get all tweets of the randomly selected user
    tweet = Tweet.all.select{ |t|
      t["user_id"] == user["id"]
    }
    if !users.include?(user) and tweet.length >= t
      users << user
      tweets << tweet
      follows << follow
      count += 1
  end
  @users = users.to_json
  @tweets = tweets.to_json
  status 200
end

# Test: get y random tweets of test user id x
get '/test/tweet?user_id=x&tweet_count=y' do
  x = params[:x]
  y = params[:y]
  user = User.find_by_id(x)
  tweets = Tweet.all.select{ |t|
      t["user_id"] == user["id"]
    }
  end
  @user = user.to_json
  @tweets = tweets.sample(y).to_json
  status 200
end

# Test: check validation
# get '/test/validate?n=n' do
# end