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



