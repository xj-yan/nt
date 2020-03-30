# endpoint related to user

class App < Sinatra::Base

  # routes for logged in user
  get "/user/profile" do
    authenticate!
    erb :profile_page, locals: {user: params}
  end
end