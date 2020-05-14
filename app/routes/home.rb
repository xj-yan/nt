# endpoint related to home
require 'sinatra/flash'
require 'sinatra/base'



class App < Sinatra::Base  
  get 'loaderio-0470e477a26613ba3324452466632e93' do
    'loaderio-0470e477a26613ba3324452466632e93'
  end

  get 'loaderio-b178fcdefb95ac035ed731504927195d' do
    'loaderio-b178fcdefb95ac035ed731504927195d'
  end

  get "/" do
    user_id = params[:user_id].to_i
    puts "user id is#{user_id}"
    if user_id != 0
      session[:user_id] = user_id
    end
    authenticate!
    @user = get_user(session[:user_id])
    erb :main
	end
  
  # routes for login and logout
  get "/index" do
    erb :index
  end

	# routes for login and logout
  get "/login" do
    erb :login
  end

  post "/login" do
    @user = User.find_by(email: params[:email])
    if @user && test_password(params[:password], @user.password_digest)
      session[:user_id] = @user.id
      redirect '/'
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
    cookies.delete :user_id
    flash[:notice] = 'You have been logged out.'
    redirect '/'
  end

  # routes for registering account 
  get "/register" do
    erb :register
  end

  post "/register" do
    user = User.find_by(email: params[:email])
    if user
      flash[:notice] = "You have an account already. Please log in!"
      redirect '/login'
    else
      begin
        @user = User.create!(id: User.maximum(:id).next, username: params[:username], email: params[:email], password_digest: hash_password(params[:password]))
        if @user.valid?
          session[:user_id] = @user.id
          redirect '/'
        end
      rescue StandardError => msg  
        flash[:notice] = "Registration Failed! #{msg}"
        redirect '/register'
      end

    end
  end

end