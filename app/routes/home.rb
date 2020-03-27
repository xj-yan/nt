# endpoint related to home
require 'sinatra/flash'
require 'bcrypt'
require 'sinatra/base'

class App < Sinatra::Base

  # TODO helpers for authentication
  # helpers SessionAuth

	enable :sessions
  register Sinatra::Flash

  helpers do
    def hash_password(password)
      BCrypt::Password.create(password).to_s
    end

    def test_password(password, hash)
      BCrypt::Password.new(hash) == password
    end

    def logged_in?
      !!session[:user_id]
    end
  end
  
  # TODO 
	get "/" do
		erb :index,locals: { title: 'NanoTwitter' }
	end
	
	# routes for login and logout
  get "/login" do
    # erb :index, locals: { title: 'Log In' }
    erb :login
  end

  post "/login" do
    user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      session[:user] = @user
      redirect '/home'
      # redirect "/user/#{@user.id}"
    elsif !user
      flash[:notice] = "User not exists. Please sign up!"
      redirect '/register'
    else
      flash[:notice] = "Incorrect password"
      redirect '/login'
    end
  end

  get "/logout" do
    session[:user_id] = nil
    redirect '/'
  end

  # routes for registering account 
  get "/register" do
    erb :register, locals: { title: 'Register' }
  end

  post "/register" do
    user = User.find_by(email: params[:email])
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect '/register'
    elsif user
      flash[:notice] = "User exists. Please log in!"
      redirect '/login'
    else
      begin
        @user = User.create!(
          id: User.maximum(:id).next,
          name: params[:username], 
          email: params[:email], 
          password: params[:password])
        session[:user_id] = @user.id
        @user.save
      rescue StandardError => msg  
        flash[:notice] = "Registration Failed! #{msg}"
        redirect '/register'
      end
      redirect '/home'
      # redirect "/user/#{@user.id}"

    end
  end

  # routes for logged in user
  get "/user/profile" do
    erb :profile_page, locals: {user: params}
  end

  # home is a protected route 
  get '/home' do
    # redirect if not loggin 
    if !logged_in?
      redirect "/login"
    # show homepage
    else
      erb :home, locals: { title: 'Home Page' }
      # uri = URI.join("http://#{settings.api}:#{settings.api_port}",
      #             "/users/", "tweet")
      # response = Net::HTTP.post_form(
      #   uri, 'user_id' => params[:x], 
      #   'tweet_count' => params[:y])
      # erb :home, locals: { title: 'Home Page' }
    end
  end
end