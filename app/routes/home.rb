# endpoint related to home

class App < Sinatra::Base

	configure do
    enable :sessions
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end
	end
	
	get "/" do
		erb :index,locals: { title: 'NanoTwitter' }
	end
	
	 # routes for login and logout
  get "/login" do
    erb :login, locals: { title: 'Log In' }
  end

  post '/login' do
    uri = URI.join("http://#{settings.api}:#{settings.api_port}",
                  "/user/", "validate")
    response = Net::HTTP.post_form(
      uri, 'email' => params[:email], 
      'password' => params[:password])
    h = response.code == "200" || response.code == "401" ? 
        JSON.parse(response.body) : {}
    if h["status"] == "success"
      # Save the user id inside the browser cookie. 
      # This is how we keep the user 
      # logged in when they navigate around our website.
      session[:user_id] = h["user_id"]
      puts session[:user_id]
      redirect '/home'
    else
    # If user's login doesn't work, send them back to the login form.
      flash[:notice] = "Login failed due to #{h["status"]}"
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
    uri = URI.join("http://#{settings.api}:#{settings.api_port}",
                  "/user/", "register")
    response = Net::HTTP.post_form(
      uri, 'name' => params[:name],
      'email' => params[:email], 
      'password' => params[:password])
    # register success
    if response.code == "200"
      h = JSON.parse(response.body)
      session[:user_id] = h["user_id"]
      redirect '/home'
    else
      flash[:notice] = "Registration failed. The email \
      may have already been registered"
      redirect '/register'
    end
  end

  # routes for logged in user
  get "/user/profile" do
    erb :profile_page, locals: {user: params}
  end

  # home is a protected route 
  get '/home' do
    if !logged_in?
      redirect "/login"
    else
      uri = URI.join("http://#{settings.api}:#{settings.api_port}",
                  "/users/", "tweet")
      response = Net::HTTP.post_form(
        uri, 'user_id' => params[:x], 
        'tweet_count' => params[:y])
      erb :home, locals: { title: 'Home Page' }
    end
  end
end