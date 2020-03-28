# endpoint related to home
require 'sinatra/flash'
require 'bcrypt'
require 'sinatra/base'

class App < Sinatra::Base

  # TODO helpers for authentication
  # helpers SessionAuth

	enable :sessions
  register Sinatra::Flash
  helpers Timeline
  helpers Authentication

  helpers do
    def hash_password(password)
      BCrypt::Password.create(password).to_s
    end

    def test_password(password, hash)
      BCrypt::Password.new(hash) == password
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
    @user = User.find_by(email: params[:email])
    if @user && test_password(params[:password], @user.password_digest)
      session[:user_id] = @user.id
      redirect '/home'
      # redirect "/user/#{@user.id}"
    elsif !@user
      flash[:notice] = "User not exists. Please sign up!"
      redirect '/register'
    else
      flash[:notice] = "Incorrect password"
      redirect '/login'
    end
  end

  get "/logout" do
    session[:user_id] = nil
    flash[:notice] = 'You have been logged out.'
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
        @user = User.create!(id: User.maximum(:id).next, username: params[:username], email: params[:email], password_digest: hash_password(params[:password]))
        if @user.valid?
          session[:user_id] = @user.id
          redirect '/home'
        end
      rescue StandardError => msg  
        flash[:notice] = "Registration Failed! #{msg}"
        redirect '/register'
      end

      # redirect "/user/#{@user.id}"

    end
  end

  # routes for logged in user
  get "/user/profile" do
    authenticate!
    erb :profile_page, locals: {user: params}
  end

  # home is a protected route 
  get '/home' do
    authenticate!
    @timeline = get_timeline(session[:user_id])
    erb :home, locals: { title: 'Home Page' }
  end
end